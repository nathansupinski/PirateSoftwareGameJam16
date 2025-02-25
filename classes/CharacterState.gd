class_name CharacterState extends Node

#stores a ref to the Character that this state belongs to
var character: Character

# Called when the character enters this state
func Enter() -> void:
	pass

# Called when the character leaves this state
func Exit() -> void:
	pass

# what happens during the process update in this state
func Process(_delta: float) -> CharacterState:
	return null

# what happens during the _physics_process update in this state
func Physics(_delta: float) -> CharacterState:
	return null

# what happens with input events in this state
func HandleInput(_event: InputEvent) -> CharacterState:
	return null
