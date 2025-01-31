extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	print("pause menu - resume pressed")
	hide()
	get_tree().paused = false

func _on_settings_button_pressed() -> void:
	print("pause menu - settings pressed")
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	print("pause menu - quit pressed")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	
func _input(event):
	if Input.is_action_just_pressed("pause") and not get_parent().find_child("UpgradeMenu").visible\
	and not $"../LoadingScreen".visible\
	and not $"../DeathScreen".visible:
		print("menu unPaused")
		get_tree().paused = false
		hide()
		get_viewport().set_input_as_handled()
