class_name CharacterState extends Node

#stores a ref to the Character that this state belongs to
static var character: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Called when the character enters this state
func Enter() -> void:
	pass

# Called when the character leaves this state
func Exit() -> void:
	pass

# what happens during the process update in this state
func Process(delta: float) -> CharacterState:
	print("Base class process running")
	return null

# what happens during the _physics_process update in this state
func Physics(delta: float) -> CharacterState:
	return null

# what happens with input events in this state
func HandleInput(event: InputEvent) -> CharacterState:
	return null
