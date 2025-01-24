class_name Character extends CharacterBody2D

signal healthChanged

@export var speed: float = 70
@export var maxHealth: int = 3
@export var characterName: String = 'Char1'
@export var collisionDamage: int = 0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effectsAnimations = $EffectsAnimationPlayer
@onready var hurtTimer = $hurtTimer
@onready var hurtBox = $hurtBox
@onready var currentHealth: int = maxHealth
@onready var stateMachine: CharacterStateMachine = $StateMachine
@onready var sprite: Sprite2D = $Sprite2D

var isHurt: bool = false
var enemyCollisions = []
var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 = Vector2.ZERO

func _init():
	pass

func _ready():
	#print("init state machine " + str(stateMachine))
	stateMachine.Initialize(self)

func _process(delta):
	pass
	
func _physics_process(delta): #TODO: need to cleanup the function overloads in Player and Enemy class so we arent duplicating. 
	move_and_slide()
	handleCollision()
	
func handleCollision():
	pass


func _on_hurt_box_area_entered(_area): pass
		
func _on_hurt_box_area_exited(_area): pass

# returns true if the animation needs to be updated
func SetDirection() -> bool: 
	var new_direction: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
		
	if direction.y == 0: 
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT #sets a direction when we have diagonal inputs
	elif direction.x == 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN #sets a direction when we have diagonal inputs
		
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	if not is_instance_of(self,Player):
		sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1 #flips the sprite left or right but also flips any child sprites. Use flip setting on the sprite instead if you dont want this behavior
	return true
	
func UpdateAnimation(state: Enums.CHARACTER_STATE_NAMES) -> void:
	match state:
		Enums.CHARACTER_STATE_NAMES.WALK:
			animation_player.play("walk_" + AnimDirection())
		Enums.CHARACTER_STATE_NAMES.IDLE:
			animation_player.play("idle_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else: 
		return "side"

func destroy() -> void:
	self.queue_free()
		
func dealDamage(damage: float):
	currentHealth = currentHealth - damage
	print(characterName + ": damaged(" + str(damage) + ") hpLeft:" + str(currentHealth))
	if(currentHealth <= 0):
		call_deferred("destroy")
