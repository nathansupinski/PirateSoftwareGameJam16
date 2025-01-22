class_name ProjectilePool extends Node2D

#arbitrary
const MAX_PROJECTILES = 200

var projectiles : Array[Projectile] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func resetProjectile(projectile : Projectile):
	projectile.Reset()
	if projectile not in projectiles:
		projectiles.append(projectile)
	#projectiles.append(projectile)
	
func Shoot(direction : Vector2):
	var proj = projectiles.pop_front()
	while not is_instance_valid(proj):
		proj = projectiles.pop_front()
	proj.direction = direction
	proj.global_position = self.global_position
	proj.visible = true
	

static func Create(scene : PackedScene, count : int, source : Weapon):
	var pool = ProjectilePool.new()
	if count <= 0 or count >= MAX_PROJECTILES:
		push_error("Invalid projectile count for projectile pool")
	for i in range(count):
		var obj = scene.instantiate() as Projectile
		obj.source = source
		obj.projectile_destroyed.connect(pool.resetProjectile)
		obj.visible=false
		ProjectileContainer.AddToPlayerProjectiles(obj)
		pool.projectiles.append(obj)
	return pool
		
