class_name CharacterStateMachine extends Node

var states: Array [CharacterState]
var prev_state: CharacterState
var cur_state: CharacterState
var character: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _enter_tree() -> void:
		if get_parent() is Character:
			character = get_parent()
			print("Set state machine parent to ", character.characterName)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if character.characterName != "Enemy1":
	#print('process tick ' + str(cur_state))
	#var shouldChange = cur_state.Process(delta)
	#print('shouldChange ' + str(shouldChange))
	ChangeState(cur_state.Process(delta))
	
func _physics_process(delta: float) -> void:
	#print('SM_physics: state is ' + str(cur_state))
	ChangeState(cur_state.Physics(delta))
	
func _unhandled_input(event: InputEvent) -> void:
	#print('SM_input: state is ' + str(cur_state))
	ChangeState(cur_state.HandleInput(event))
	
func Initialize(characterInput: Character ) -> void:
	self.character = characterInput
	states = []
	
	for c in get_children():
		print(character.characterName + ' child ' + str(c))
		if c is CharacterState:
			c.character = character
			states.append(c)
			
	if states.size() > 0:
		#print("size not 0")
		states[0].character = character
		ChangeState(states[0]) #TODO: refactor to get idle state directly so the order of children doesnt matter
		process_mode = Node.PROCESS_MODE_INHERIT
		#print(character.characterName + 'chagned state to ' + str(states[0]))
		#print('cur_state is ' + str(cur_state))
		#print('prev_state is ' + str(prev_state))
	
	print(character.characterName + " Inited " + str(states.size()) + " character states.")

func ChangeState(new_state: CharacterState) -> void:
	#print('ChangeState: new_state is ' + str(new_state))
	#if character.characterName != "Enemy1" && new_state == null:
			#print('null state')
	if new_state == null || new_state == cur_state:
		return
		#if character.characterName != "Enemy1":
			#print(character.characterName + ' no change')

	if cur_state:
		cur_state.Exit()
		
	prev_state = cur_state
	cur_state = new_state
	#print('ChangeState: cur_state is ' + str(cur_state))
	#print('ChangeState: prev_state is ' + str(prev_state))
	cur_state.Enter()
