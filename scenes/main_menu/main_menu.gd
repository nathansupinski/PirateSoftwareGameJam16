extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	print("Play pressed")
	get_tree().change_scene_to_file("res://scenes/main/main_scene.tscn")


func _on_quit_button_pressed() -> void:
	print("Quit pressed")
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	print("Settings pressed")
