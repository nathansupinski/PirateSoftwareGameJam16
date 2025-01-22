class_name Weapon extends Node2D

@export var weaponData : WeaponData
@export var projectile : PackedScene
@export var projectileSprite : Texture2D
@onready var _attackTimer : Timer = $AttackTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


## consider object pooling if we have performance issues
func Shoot(direction : Vector2):
	if not _attackTimer.is_stopped():
		return
	var object : Projectile = Weapon.CreateProjectile(projectile,direction,self,projectileSprite)
	
	#var object : Projectile = projectile.instantiate()
	#object.direction = direction
	#object.source = self
	#object.sprite
	pass


static func CreateProjectile(projectileScene : PackedScene, 
direction : Vector2, source : Weapon, sprite : Texture2D) -> Projectile:
	var object = projectileScene.instantiate() as Projectile #error if not?
	var data : WeaponData = source.weaponData
	object.direction = direction
	object.sprite.texture = sprite
	
	return object
	
