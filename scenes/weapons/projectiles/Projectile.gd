class_name Projectile extends Area2D


##If we need to change how projectiles are handled on death.
##For now, just destroy projectile
static var OnDestroy : Callable = func(projectile : Projectile) -> void:
	projectile.queue_free()



signal projectile_destroyed()

var source : Weapon = null 
var direction : Vector2 = Vector2.ZERO
var _traveled : float = 0
#@onready var sprite : Sprite2D = $Sprite2D
func _ready() -> void:
	pass # Replace with function body.

func _exit_tree() -> void:
	print(self, " Destroyed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if _traveled > source.weaponData.range:
		OnDestroy.call_deferred(self)
		
	var deltaPos = source.weaponData.projectileSpeed*direction*delta
	_traveled += deltaPos
	position += deltaPos
