extends CanvasLayer

var genDone = false
var chunksDone = false
@export var generator : NoiseGenerator
var initialTasks = -1
@onready var label: Label = $Label
@onready var navigation_region_2d: NavigationRegion2D = $"../NavigationRegion2D"
@onready var start_button: TextureButton = $TextureButton
@onready var menu_hover_sound_player: AudioStreamPlayer = $"../MenuHoverSoundPlayer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.visible = false
	start_button.pressed.connect(_on_start_clicked)
	SignalBus.procGenDone.connect(_on_gen_finished)
	SignalBus.procGenFirstChunkLoadDone.connect(_on_first_chunk_finished)
	navigation_region_2d.bake_finished.connect(_on_bake_finished)
	start_button.mouse_entered.connect(menu_hover_sound_player.play)
	get_tree().paused = true
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	#if genDone and chunksDone:
		#var gaeaRender = generator.find_child("ThreadedTilemapGaeaRenderer")
		#if len(gaeaRender._tasks)!=0:
			#return
		#self.visible = false
		#genDone = false
		#chunksDone = false
		#get_tree().paused = false

func _on_gen_finished() -> void:
	genDone = true
	label.text = "Baking nav mesh..."
	print("Gen done")
	
func _on_first_chunk_finished() -> void:
	chunksDone = true
	print("Chunks done")
	
func _on_bake_finished() -> void:
	print("bake done")
	label.visible = false
	start_button.visible = true
	
	
func _on_start_clicked() -> void:
	self.visible = false
	get_tree().paused = false
	SignalBus.gameStart.emit()
