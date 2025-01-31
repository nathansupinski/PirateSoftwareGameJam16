extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_restart_button_pressed() -> void:
	print("reset clicked")
	self.hide()
	#get_tree().unload_current_scene()
	print("BACK TO MENU ",get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn"))
	
	
