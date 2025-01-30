class_name Enemy extends Character

const my_scene = preload("res://scenes/enemy/enemy.tscn")

@export var player: Player
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var nav_tick_timer: Timer = $NavigationAgent2D/NavTickTimer
@export var deathSprites : CharacterSprites
@onready var growl_player: AudioStreamPlayer = $GrowlPlayer
@onready var growl_timer: Timer = $GrowlTimer


const BUG_GROWLS = [
	preload("res://sound/enemies/bug_growl_1.wav"),
	preload("res://sound/enemies/bug_growl_2.wav"),
	preload("res://sound/enemies/bug_growl_3.wav")
]

var xp_container: Node2D


func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(characterName + "init state machine " + str(stateMachine))
	stateMachine.Initialize(self)
	xp_container = get_node("../../PickupContainer/xpContainer") #is there a better way to init this?  @onready didnt seem to find it correctly
	nav_tick_timer.wait_time = randf_range(.5,.7)
	growl_timer.wait_time = randf_range(5,8)
	growl_timer.start()
	growl_timer.timeout.connect(_on_growl_timer)

func _process(delta: float) -> void:
	super(delta)
	
func _physics_process(delta: float) -> void:
	if currentHealth <= 0: ##Just need to get things working
		return
	direction = to_local(navigationAgent.get_next_path_position()).normalized()
	velocity = direction * speed
	super(delta)
	
static func new_enemy(player: Player, name: String, speed := 50.0, health := 100,\
 maxHealth:= 100, collisionDamage:=20, position: Vector2 = Vector2(0,0)) -> Enemy:
	var newEnemy: Enemy = my_scene.instantiate()
	newEnemy.player = player
	newEnemy.maxHealth = maxHealth
	newEnemy.currentHealth = health
	newEnemy.speed = speed
	newEnemy.characterName = name
	newEnemy.collisionDamage = collisionDamage
	newEnemy.position = position
	return newEnemy

func _on_growl_timer() -> void:
	var growlChance = randi_range(1,100)
	if growlChance > 95:
		var growlRoll = randi_range(0,2)
		growl_player.stream = BUG_GROWLS[growlRoll]
		growl_player.play()

func _on_nav_tick_timer_timeout() -> void:
	PathToPlayer()

func PathToPlayer() -> void:
	navigationAgent.target_position =  player.global_position
	
func destroy() -> void:
	SignalBus.enemyDied.emit(position)
	$hurtBox.queue_free()
	$CollisionShape2D.queue_free()
	$hitBox.queue_free()
	$Sprite2D.texture = getDirectionalTexture(deathSprites)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	xp_container.add_child(XpPickup.new_xpPickup(position))
	super()
