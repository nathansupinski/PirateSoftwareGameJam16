extends CanvasLayer

var genDone = false
var chunksDone = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.procGenDone.connect(_on_gen_finished)
	SignalBus.procGenFirstChunkLoadDone.connect(_on_first_chunk_finished)
	pass # Replace with function body.

func _process(delta: float) -> void:
	if genDone and chunksDone:
		self.visible = false
		genDone = false
		chunksDone = false

func _on_gen_finished() -> void:
	genDone = true
	print("Gen done")
	
func _on_first_chunk_finished() -> void:
	chunksDone = true
	print("Chunks done")
