extends CanvasLayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_restart_button_pressed() -> void:
	print("reset clicked")
	get_tree().reload_current_scene()
	self.hide()
	
	
