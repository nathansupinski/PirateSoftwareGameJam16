class_name VisibleArea2D extends Area2D

var enableDebugDraw = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 200
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	if enableDebugDraw:
		var collision_shape = self.get_child(0)
		if collision_shape and collision_shape.shape:
			var shape = collision_shape.shape

			# Check if it's a RectangleShape2D
			if shape is RectangleShape2D:
				var rect_size = shape.size / 2
				var points = [
					Vector2(-rect_size.x, -rect_size.y),
					Vector2(rect_size.x, -rect_size.y),
					Vector2(rect_size.x, rect_size.y),
					Vector2(-rect_size.x, rect_size.y),
				]
				z_index = 150
				draw_polyline(points + [points[0]], Color(245, 10, 10))  # Close the rectangle with the first point
