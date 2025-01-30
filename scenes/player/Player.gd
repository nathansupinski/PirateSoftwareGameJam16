class_name Player extends Character

const ROTATION_IMAGES = 40




@export var knockbackPower: int = 1500
@onready var aimIndicator : Node2D = $AimIndicator
@onready var equipment : Equipment = $Equipment
@onready var xp_bar: ProgressBar = %xpBar
@onready var level_hud: Label = %level
@onready var hurt_box: Area2D = $hurtBox

var mouseAngle : float 
signal energyChanged

var totalXp:int = 0
var xpThisLevel = 0
var xpToLevel: int = 20
var level: int = 1
var upgradeLevel = 1
var xpScaleFactor: float = 1.5
var currentEnergy: int = 60
var maxEnergy: int = 150
var pickupRadius : float = 100 :
	get():
		return pickupRadius
	set(value):
		if value < 0:
			return
		$"PickupArea/CollisionShape2D".shape.radius=value
		pickupRadius = value

#init player specific properties
func _init():
	super()
	speed = 400
	maxHealth = 800
	currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	print("init hp", currentHealth)
	#$AnimationTree.set("parameters",not stateMachine.cur_state.name=="walk" and not direction.x !=0)


func _ready():
	stateMachine.Initialize(self)
	if xp_bar:
		xp_bar.max_value = xpToLevel
		xp_bar.value = xpThisLevel
	hurt_box.connect("area_entered", _on_area_entered)
	healthChanged.connect(func(hp): print("hp changed",hp))
	SignalBus.playerUpgradesChanged.connect(_on_player_upgrades_changed)
	print("rdy hp", currentHealth)

func _process(delta):
	super(delta)
	handleInput()
	
	
func _on_player_upgrades_changed(card: UpgradeCard) -> void:
	print("updating player stats")
	speed = StatBroker.transformPlayerNumeric(Enums.PlayerNumericStatID.SPEED, speed)
	setMaxHealth(StatBroker.transformPlayerNumeric(Enums.PlayerNumericStatID.MAX_HP, maxHealth))
	
	
func rotationToTorsoIndex(radians : float) -> int:
	#Angles in godot are funky, so this is to put the range back to [0,2*pi]
	radians = Utils.vec_angle_correct(radians)
	const step = 2*PI/ROTATION_IMAGES
	const OFFSET = int(ceil(5*PI/4/step))
	# first frame is a 225 degree angle, so offset by that (25 indexes)
	var out = int(radians/step) - OFFSET
	if out < 0:
		out += ROTATION_IMAGES
		
	return out
	
	

	
func _physics_process(delta):
	move_and_slide()
	handleCollision()

	##Aim Indicator
	var mousePos : Vector2 = get_local_mouse_position()
	mouseAngle = mousePos.angle()

	
	$Torso.frame = rotationToTorsoIndex(mouseAngle)
	$Equipment.weapon1.spawnPos.position = Vector2.from_angle(mouseAngle-PI/4)*$Equipment.weapon1.rotateRadius
	$"Equipment".weapon1.sprite.frame = $Torso.frame
	if $Equipment.weapon2:
		$Equipment.weapon2.spawnPos.position = Vector2.from_angle(mouseAngle+PI/4)*$Equipment.weapon2.rotateRadius
		$Equipment.weapon2.sprite.frame = $Torso.frame
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)
				
	


func handleInput():
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	##TODO CHANGE aimIndicator stuff
	if Input.is_action_pressed("weapon1"):
		equipment.FireWeapon1(Vector2.from_angle(mouseAngle))
	elif Input.is_action_just_released("weapon1"):
		equipment.CancelChargeWeapon1()
	if Input.is_action_pressed("weapon2"):
		equipment.FireWeapon2(Vector2.from_angle(mouseAngle))
	elif Input.is_action_just_released("weapon2"):
		equipment.CancelChargeWeapon2()
	
		
	

	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func hurtByEnemy(area):
	if not hurtTimer.is_stopped():
		print(hurtTimer.time_left, hurtTimer.is_stopped()) ## I think getting damaged by 10 enemies at once is too punishing
		return
	currentHealth -= area.get_parent().collisionDamage
	SignalBus.playerDamaged.emit(area.get_parent(), area.get_parent().collisionDamage)
	if currentHealth <= 0:
		SignalBus.playerDied.emit(area.get_parent())
		print('death signal emited')
	healthChanged.emit(currentHealth)
	isHurt = true
	
	knockback(area.get_parent().velocity)
	effectsAnimations.play("hurtBlink")
	hurtTimer.start()
	#await effectsAnimations.completed
	await hurtTimer.timeout
	effectsAnimations.play("RESET")
	isHurt = false
	pass

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

#temp overload parent class until we get rid of placeholder animations
func UpdateAnimation(state: Enums.CHARACTER_STATE_NAMES) -> void:
	match state:
		Enums.CHARACTER_STATE_NAMES.WALK:
			$AnimationPlayer.play("move")
			pass
		Enums.CHARACTER_STATE_NAMES.IDLE:
			$AnimationPlayer.play("idle")
			pass
			
func applyXp(xp: int) -> void:
	if not xp_bar:
		print("No xp bar")
		return
	totalXp += xp
	xpThisLevel += xp
	xp_bar.value = xpThisLevel
	
	if xpThisLevel >= xpToLevel:
		var remainder = xpThisLevel - xpToLevel
		level += 1
		xpThisLevel = remainder
		xpToLevel = ceil(xpToLevel * xpScaleFactor)
		xp_bar.max_value = xpToLevel
		xp_bar.value = xpThisLevel
		level_hud.text = str(level)
		print("")
		(func():SignalBus.playerLevelup.emit()).call_deferred()
		#SignalBus.playerLevelup.emit()
		
func _on_area_entered(area: Area2D) -> void: #wanted to keep this code in Pickup class but seems more performant to have the player do the checking
	if is_instance_of(area, Pickup):
		pass
		#(area as Pickup).apply(self)


func _on_pickup_area_area_entered(area: Area2D) -> void:
	print(area)
	if is_instance_of(area,Pickup):
		var tween = get_tree().create_tween()
		tween.tween_property(area,"global_position",self.global_position,0.1)
		await tween.finished
		if is_instance_valid(area):
			(area as Pickup).apply(self)
		
		#get_tree().root.add_child(tween)
