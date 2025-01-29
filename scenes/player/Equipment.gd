class_name Equipment extends Node2D




signal weapon2_changed(weapon)

@export var weapon1 : Weapon 
@export var weapon2 : Weapon : 
	get():
		return weapon2
	set(value):
		weapon2_changed.emit(value)
		weapon2 = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon1.sprite.texture = Global.weapons[weapon1.weaponData.name]["left"]
	if weapon2:
		weapon2.sprite.texture = Global.weapons[weapon2.weaponData.name]["right"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func AddUpgrade(tag : String, upgrade) -> void:
	
	pass

func FireWeapon1(direction : Vector2) -> void:
	weapon1.Shoot(direction)

func CancelChargeWeapon1() -> void:
	weapon1.CancelCharge()

func FireWeapon2(direction : Vector2) -> void:
	if weapon2:
		weapon2.Shoot(direction)

func CancelChargeWeapon2() -> void:
	if weapon2:
		weapon2.CancelCharge()
