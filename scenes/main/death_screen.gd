extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_restart_button_pressed() -> void:
	print("reset clicked")
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
	self.hide()
	
	
