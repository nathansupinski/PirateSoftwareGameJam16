class_name Weapon extends Node2D

@export var weaponData : WeaponData
@export var projectile : PackedScene
@export var projectileSprite : Texture2D
@onready var _attackTimer : Timer = $AttackTimer

var projectilePool : ProjectilePool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_attackTimer.wait_time = weaponData.cooldown
	projectilePool = ProjectilePool.Create(projectile,200,self)
	$"Sprite2D/SpawnPosition".add_child(projectilePool)


func Shoot(direction : Vector2):
	if _attackTimer.is_paused() or _attackTimer.is_stopped():
		var count = weaponData.projectileCount
		const maxSpread = deg_to_rad(60)
		var step = maxSpread / count
		for i in range(-count/2,count/2+1,1):
			#print(i)
			projectilePool.Shoot(direction.rotated(i*step))
		projectilePool.Shoot(direction)
		_attackTimer.start()
	
