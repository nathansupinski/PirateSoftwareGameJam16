class_name CharacterState_Idle extends CharacterState
@onready var walk = $"../walk"
# Called when the character enters this state
func Enter() -> void:
	print(character.characterName + ' Entered Idle State')
	character.UpdateAnimation(Enums.CHARACTER_STATE_NAMES.IDLE)

# Called when the character leaves this state
func Exit() -> void:
	pass
	
func _ready() -> void:
	pass

# what happens during the process update in this state
func Process(delta: float) -> CharacterState:
	if character.direction != Vector2.ZERO:
		return walk
	character.velocity = Vector2.ZERO
	
	if character.SetDirection():
		character.UpdateAnimation(Enums.CHARACTER_STATE_NAMES.IDLE)

	return null

# what happens during the _physics_process update in this state
func Physics(delta: float) -> CharacterState:
	return null

# what happens with input events in this state
func HandleInput(event: InputEvent) -> CharacterState:
	return null
