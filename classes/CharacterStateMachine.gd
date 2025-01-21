class_name CharacterStateMachine extends Node

var states: Array [CharacterState]
var prev_state: CharacterState
var cur_state: CharacterState
var character: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ChangeState(cur_state.Process(delta))
	
func _physics_process(delta: float) -> void:
	ChangeState(cur_state.Physics(delta))
	
func _unhandled_input(event: InputEvent) -> void:
	ChangeState(cur_state.HandleInput(event))
	
func Initialize(characterInput: Character ) -> void:
	self.character = characterInput
	states = []
	
	for c in get_children():
		if c is CharacterState:
			c.character = character
			states.append(c)
			
	if states.size() > 0:
		states[0].character = character
		ChangeState(states[0]) #TODO: refactor to get idle state directly so the order of children doesnt matter
		process_mode = Node.PROCESS_MODE_INHERIT
	
	#print(character.characterName + " Inited " + str(states.size()) + " character states.")

func ChangeState(new_state: CharacterState) -> void:
	if new_state == null || new_state == cur_state:
		return

	if cur_state:
		cur_state.Exit()
		
	prev_state = cur_state
	cur_state = new_state
	cur_state.Enter()
