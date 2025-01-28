class_name Character extends CharacterBody2D

signal healthChanged
const UP = Vector2.UP
const LEFT = Vector2.LEFT
const DOWN = Vector2.DOWN
const RIGHT = Vector2.RIGHT

const UP_LEFT = Vector2(-1,-1)
const DOWN_LEFT = Vector2(-1,1)
const UP_RIGHT = Vector2(1,-1)
const DOWN_RIGHT = Vector2(1,1)

@export var speed: float = 70
@export var maxHealth: int = 3
@export var characterName: String = 'Char1'
@export var collisionDamage: int = 0
@export var spriteSheets : CharacterSprites


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

const ANG_45 = PI/4

const RIGHTA = 0
const UP_RIGHTA = ANG_45
const UPA = UP_RIGHTA + ANG_45
const UP_LEFTA = UPA + ANG_45
const LEFTA = UP_LEFTA +ANG_45
const DOWN_LEFTA = LEFTA + ANG_45
const DOWNA = DOWN_LEFTA+ANG_45
const DOWN_RIGHTA = DOWNA+ANG_45

func getDirectionalTexture(sprites : CharacterSprites) -> Texture2D:
	var angle = Utils.vec_angle_correct(direction.angle())
	if Utils.in_range(angle,UP_LEFTA,ANG_45/2) or Utils.in_range(angle,UP_RIGHTA,ANG_45/2): #UP LEFT, UP RIGHT
		return sprites.SPRITE_UP_SIDE
	elif Utils.in_range(angle,LEFTA,ANG_45/2) or Utils.in_range(angle,RIGHTA,ANG_45/2): #LEFT, RIGHT
		return sprites.SPRITE_SIDE
	elif Utils.in_range(angle,DOWN_LEFTA,ANG_45/2) or Utils.in_range(angle,DOWN_RIGHTA,ANG_45/2): #DOWN LEFT, DOWN RIGHT
		return sprites.SPRITE_DOWN_SIDE
	elif Utils.in_range(angle,DOWNA,ANG_45/2): # DOWN
		return sprites.SPRITE_DOWN
	elif Utils.in_range(angle,UPA,ANG_45/2): #UP
		return spriteSheets.SPRITE_UP
	return sprites.SPRITE_DOWN
	
func _process(delta):
	if currentHealth <= 0:
		return
	var directionCeil = direction.ceil()
	var angle = Utils.vec_angle_correct(direction.angle())
	
	$Sprite2D.texture = getDirectionalTexture(spriteSheets)
	
	
	sprite.flip_h = true if direction.x > 0 else false
	
	#pass
	
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
	#if not is_instance_of(self,Player):
	#sprite.flip_h = false if direction.x >= 0 else true #flips the sprite left or right but also flips any child sprites. Use flip setting on the sprite instead if you dont want this behavior
	return true
	
func UpdateAnimation(state: Enums.CHARACTER_STATE_NAMES) -> void:
	match state:
		Enums.CHARACTER_STATE_NAMES.WALK:
			animation_player.play("move")
		Enums.CHARACTER_STATE_NAMES.IDLE:
			animation_player.play("idle")

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
		destroy()

func setMaxHealth(newMaxHealth: int):
	maxHealth = newMaxHealth
	healthChanged.emit(currentHealth)
	
func setCurrentHealth(newCurrentHealth: int):
	currentHealth = newCurrentHealth
	healthChanged.emit(currentHealth)
	
