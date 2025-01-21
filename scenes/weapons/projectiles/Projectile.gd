class_name Projectile extends StaticBody2D

var source : Weapon = null 
var direction : Vector2 = Vector2.ZERO

#@export_exp_easing("attenuation") var decel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var vel = self.constant_linear_velocity
	#move_and_collide()
