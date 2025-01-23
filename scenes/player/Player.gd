class_name Player extends Character

@export var knockbackPower: int = 1500
@onready var aimIndicator : Node2D = $AimIndicator
@onready var equipment : Equipment = $Equipment
@onready var xp_bar: ProgressBar = $"../PlayerHUD/MarginContainer/HBoxContainer/MarginContainer/xpBar"
@onready var level_hud: Label = $"../PlayerHUD/MarginContainer/HBoxContainer/level"
@onready var hurt_box: Area2D = $hurtBox

var totalXp:int = 0
var xpThisLevel = 0
var xpToLevel: int = 10
var level: int = 1
var xpScaleFactor: float = 1.3

#init player specific properties
func _init():
	super()
	speed = 100
	maxHealth = 100
	currentHealth = maxHealth

func _ready():
	stateMachine.Initialize(self)
	xp_bar.max_value = xpToLevel
	xp_bar.value = xpThisLevel
	hurt_box.connect("area_entered", _on_area_entered)

func _process(delta):
	handleInput()
	
func _physics_process(delta):
	move_and_slide()
	handleCollision()

	##Aim Indicator
	var mousePos : Vector2 = get_local_mouse_position()
	aimIndicator.rotation = mousePos.angle()
	
	## Weapon
	
	if Input.is_action_pressed("weapon1"):
		equipment.weapon1.Shoot(Vector2.from_angle(aimIndicator.rotation))
	
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)
				
	

func handleInput():
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func hurtByEnemy(area):
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
	await hurtTimer.timeout
	effectsAnimations.play("RESET")
	isHurt = false

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

#temp overload parent class until we get rid of placeholder animations
func UpdateAnimation(state: Enums.CHARACTER_STATE_NAMES) -> void:
	match state:
		Enums.CHARACTER_STATE_NAMES.WALK:
			animation_player.play("walk_" + AnimDirection())
		Enums.CHARACTER_STATE_NAMES.IDLE:
			animation_player.play("idle_down") #temp
			
func applyXp(xp: int) -> void:
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

func _on_area_entered(area: Area2D) -> void: #wanted to keep this code in Pickup class but seems more performant to have the player do the checking
	if area is Pickup:
		area.apply(self)
