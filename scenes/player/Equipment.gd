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
	if weapon2:
		weapon2.sprite.texture = Global.weapons[weapon2.weaponData.name]["right"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func AddUpgrade(tag : String, upgrade) -> void:
	
	pass

func FireWeapon1() -> void:
	for tag in weapon1.weaponData.tags:
		pass
	pass

func FireWeapon2() -> void:
	for tag in weapon2.weaponData.tags:
		pass
	pass
