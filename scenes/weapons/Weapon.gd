class_name Weapon extends Node2D

@export var weaponData : WeaponData
@export var projectile : PackedScene
@export var projectileSprite : Texture2D
@onready var _attackTimer : Timer = $AttackTimer

var projectilePool : ProjectilePool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_attackTimer.wait_time = weaponData.cooldown
	projectilePool = ProjectilePool.Create(projectile,50,self)
	$"Sprite2D/SpawnPosition".add_child(projectilePool)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(_attackTimer.paused, _attackTimer.time_left)
	pass
	


## consider object pooling if we have performance issues
func Shoot(direction : Vector2):
	if _attackTimer.is_paused() or _attackTimer.is_stopped():
		projectilePool.Shoot(direction)
		_attackTimer.start()

	pass


#static func CreateProjectile(projectileScene : PackedScene, 
#direction : Vector2, source : Weapon, sprite : Texture2D) -> Projectile:
	#var object = projectileScene.instantiate() as Projectile #error if not?
	#var data : WeaponData = source.weaponData
	#object.direction = direction
	#object.sprite.texture = sprite
	#
	#return object
	
