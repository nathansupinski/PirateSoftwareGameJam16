class_name Weapon extends Node2D

@export var weaponData : WeaponData
var _baseStats : WeaponData
@export var projectile : PackedScene
@export_range(1,ProjectilePool.MAX_PROJECTILES) var projectilePoolSize : int
@export var rotateRadius : float = 60
@onready var _attackTimer : Timer = $AttackTimer
@onready var sprite = $Sprite2D
@onready var spawnPos = %SpawnPosition

var projectilePool : ProjectilePool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_attackTimer.wait_time = weaponData.fireRate
	weaponData = weaponData.duplicate()
	projectilePool = ProjectilePool.Create(projectile,projectilePoolSize,self)
	$"Sprite2D/SpawnPosition".add_child(projectilePool)
	_baseStats = weaponData.duplicate()
	#print()
		
	
		#rightWepData.set(name,brokerFn.call(Enums.StringToWeaponNumericStatID(name),Enums.WeaponSlot.RIGHT_ARM,rightWepData.get(name)))
	#for wd in weaponData.get_property_list():
		#print(wd["name"] not in WeaponData and wd["name"] in weaponData ," ", wd["name"])
	


func Shoot(direction : Vector2):
	if _attackTimer.is_paused() or _attackTimer.is_stopped():
		var count : int = weaponData.projectileCount
		const maxSpread = deg_to_rad(60)
		var step : float = maxSpread / float(count)
		for i in range(-count/int(2),count/int(2)+1,1):
			#print(i,direction.rotated(i*step))
			projectilePool.Shoot(direction.rotated(i*step))
		$AudioStreamPlayer.stream = weaponData.shotSound
		$AudioStreamPlayer.play()
		#await $AudioStreamPlayer.finished
		#projectilePool.Shoot(direction)
		_attackTimer.start(weaponData.fireRate)
	

func CancelCharge():
	pass
