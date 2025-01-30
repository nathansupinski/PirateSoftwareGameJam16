extends CanvasLayer

var genDone = false
var chunksDone = false
@export var generator : NoiseGenerator
var initialTasks = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.procGenDone.connect(_on_gen_finished)
	SignalBus.procGenFirstChunkLoadDone.connect(_on_first_chunk_finished)
	get_tree().paused = true
	print("HERE " ,get_tree().paused)
	pass # Replace with function body.

func _process(delta: float) -> void:
	if genDone and chunksDone:
		var gaeaRender = generator.find_child("ThreadedTilemapGaeaRenderer")
		if len(gaeaRender._tasks)!=0:
			return
		self.visible = false
		genDone = false
		chunksDone = false
		get_tree().paused = false

func _on_gen_finished() -> void:
	genDone = true
	print("Gen done")
	
func _on_first_chunk_finished() -> void:
	chunksDone = true
	print("Chunks done")
