class_name AimIndicator extends Sprite2D

@export var radius : float = 5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = Vector2.from_angle(self.rotation)*radius
	#print(self.rotation)
