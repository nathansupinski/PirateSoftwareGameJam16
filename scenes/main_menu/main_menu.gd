extends Control
@onready var menu_music_player: AudioStreamPlayer = $MenuMusicPlayer
@onready var play_button: TextureButton = $MarginContainer/VBoxContainer/MarginContainer/PlayButton
@onready var settings_button: TextureButton = $MarginContainer/VBoxContainer/MarginContainer3/SettingsButton
@onready var quit_button: TextureButton = $MarginContainer/VBoxContainer/MarginContainer2/QuitButton
@onready var button_hover_player: AudioStreamPlayer = $ButtonHoverPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused= false
	menu_music_player.play()
	play_button.mouse_entered.connect(button_hover_player.play)
	settings_button.mouse_entered.connect(button_hover_player.play)
	quit_button.mouse_entered.connect(button_hover_player.play)
	
	if not play_button.pressed.is_connected(_on_play_button_pressed):
		play_button.pressed.connect(_on_play_button_pressed)
	if not settings_button.pressed.is_connected(_on_settings_button_pressed):
		settings_button.pressed.connect(_on_settings_button_pressed)
	if not quit_button.pressed.is_connected(_on_quit_button_pressed):
		quit_button.pressed.connect(_on_quit_button_pressed)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().paused= false
	


func _on_play_button_pressed() -> void:
	print("Play pressed")
	print(get_tree().change_scene_to_file("res://scenes/UI/WeaponSelect.tscn"))


func _on_quit_button_pressed() -> void:
	print("Quit pressed")
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	print("Settings pressed")
