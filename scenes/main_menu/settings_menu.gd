extends CanvasLayer

@onready var back_button: Button = %BackButton
@onready var master_volume_slider: HSlider = %MasterVolumeSlider
@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = %SfxVolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_volume_slider.value_changed.connect(_on_master_volume_changed)
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	sfx_volume_slider.value_changed.connect(_on_sfx_volume_changed)
	back_button.pressed.connect(_on_back_clicked)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_master_volume_changed(value) -> void:
	print("slider", value)
	setVolume("Master", value)
	
func _on_music_volume_changed(value) -> void:
	print("slider", value)
	setVolume("Master", value)
	
func _on_sfx_volume_changed(value) -> void:
	print("slider", value)
	setVolume("Master", value)
	
func _on_back_clicked() -> void:
	self.visible = false
	
func setVolume(bus: String, value: int) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus), value == -30)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), value)
