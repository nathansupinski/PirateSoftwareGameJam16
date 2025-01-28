class_name Enemy extends Character

const my_scene = preload("res://scenes/enemy/enemy.tscn")

@export var player: Player
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var nav_tick_timer: Timer = $NavigationAgent2D/NavTickTimer
@export var deathSprites : CharacterSprites

var xp_container: Node2D


func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#print(characterName + "init state machine " + str(stateMachine))
	stateMachine.Initialize(self)
	xp_container = get_node("../../../PickupContainer/xpContainer") #is there a better way to init this?  @onready didnt seem to find it correctly
	nav_tick_timer.wait_time = randf_range(.5,.7)

	
	
func _physics_process(delta: float) -> void:
	if currentHealth <= 0: ##Just need to get things working
		return
	direction = to_local(navigationAgent.get_next_path_position()).normalized()
	velocity = direction * speed
	super(delta)
	
static func new_enemy(player: Player, name: String, speed := 50.0, health := 100,\
 maxHealth:= 100, collisionDamage:=20, position: Vector2 = Vector2(0,0)) -> Enemy:
	var new_enemy: Enemy = my_scene.instantiate()
	new_enemy.player = player
	new_enemy.maxHealth = maxHealth
	new_enemy.currentHealth = health
	new_enemy.speed = speed
	new_enemy.characterName = name
	new_enemy.collisionDamage = collisionDamage
	new_enemy.position = position
	return new_enemy



func _on_nav_tick_timer_timeout() -> void:
	PathToPlayer()

func PathToPlayer() -> void:
	navigationAgent.target_position =  player.global_position
	
func destroy() -> void:
	$hurtBox.queue_free()
	$CollisionShape2D.queue_free()
	$hitBox.queue_free()
	$Sprite2D.texture = getDirectionalTexture(deathSprites)
	$AnimationPlayer.stop()
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	print("xp container", xp_container)
	xp_container.add_child(XpPickup.new_xpPickup(position))
	super()
