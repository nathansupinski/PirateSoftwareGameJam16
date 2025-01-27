class_name Weapon extends Node2D

@export var weaponData : WeaponData
@export var projectile : PackedScene
@onready var _attackTimer : Timer = $AttackTimer
@onready var sprite = $Sprite2D

var projectilePool : ProjectilePool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_attackTimer.wait_time = weaponData.fireRate
	projectilePool = ProjectilePool.Create(projectile,200,self)
	$"Sprite2D/SpawnPosition".add_child(projectilePool)
	


func Shoot(direction : Vector2):
	if _attackTimer.is_paused() or _attackTimer.is_stopped():
		var count : int = weaponData.projectileCount
		const maxSpread = deg_to_rad(60)
		var step : float = maxSpread / float(count)
		for i in range(-count/2,count/2+1,1):
			projectilePool.Shoot(direction.rotated(i*step))
		$AudioStreamPlayer.stream = weaponData.shotSound
		$AudioStreamPlayer.play()
		#projectilePool.Shoot(direction)
		_attackTimer.start()
	

func CancelCharge():
	pass
