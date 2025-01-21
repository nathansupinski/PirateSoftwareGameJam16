class_name Weapon extends Node2D

@export var weaponData : WeaponData
@export var projectile : PackedScene
@export var projectileSprite : Texture2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func Shoot(direction : Vector2):
	var object : Projectile = projectile.instantiate()
	object.direction = direction
	object.source = self
	
	pass
