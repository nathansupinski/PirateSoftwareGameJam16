class_name AudioSettings extends GridContainer

@onready var effects_slider: HSlider = %EffectsSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var master_slider: HSlider = %MasterSlider
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effects_slider.value_changed.connect(_on_effects_slider_changed)
	music_slider.value_changed.connect(_on_music_slider_changed)
	master_slider.value_changed.connect(_on_master_slider_changed)
	



func update_audio_bus(audio_bus_name: String, value: float) -> void:
	var audio_bus_index: int = AudioServer.get_bus_index(audio_bus_name)
	
	if audio_bus_index == -1:
		print("Audio Bus Not Found: " + audio_bus_name)
		return
	
	AudioServer.set_bus_volume_db(audio_bus_index, linear_to_db(value))
# Called every frame. 'delta' is the elapsed time since the previous frame.

	
func _on_effects_slider_changed(value: float) -> void:
	update_audio_bus("Effects", value)


func _on_master_slider_changed(value: float) -> void:
	update_audio_bus("Master", value)


func _on_music_slider_changed(value: float) -> void:
	update_audio_bus("Music", value)
