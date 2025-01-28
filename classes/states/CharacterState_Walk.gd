class_name CharacterState_Walk extends CharacterState

@onready var idleState: CharacterState = $"../idle"

# Called when the player enters this state
func Enter() -> void:
	#print(character.characterName + ' Entered Walk State')
	character.UpdateAnimation(Enums.CHARACTER_STATE_NAMES.WALK)
	

# Called when the player leaves this state
func Exit() -> void:
	pass

# what happens during the process update in this state
func Process(delta: float) -> CharacterState:
	if character.direction == Vector2.ZERO:
		return idleState
		
	character.velocity = character.direction * character.speed
	
	if character.SetDirection():
		character.UpdateAnimation(Enums.CHARACTER_STATE_NAMES.WALK)
	
	
	return null

# what happens during the _physics_process update in this state
func Physics(delta: float) -> CharacterState:
	return null

# what happens with input events in this state
func HandleInput(event: InputEvent) -> CharacterState:
	return null
