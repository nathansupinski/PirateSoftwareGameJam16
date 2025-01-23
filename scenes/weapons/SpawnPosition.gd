@tool
extends Node2D


@export var debugColor : Color = Color("AQUAMARINE",0.5)
# Called when the node enters the scene tree for the first time.

## Not working how i expected
#func _ready() -> void:
	#pass # Replace with function body.
#
#
##if
#func _draw() -> void:
	#if not Engine.is_editor_hint():
		#return
	##debugColor.a = 0.5
	#var pos = self.position
	#
	#draw_circle(pos,8.0,debugColor)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#if not Engine.is_editor_hint():
		#return
	#print(self.position)
	#queue_redraw()
