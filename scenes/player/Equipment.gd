class_name Equipment extends Node2D




signal weapon2_changed(weapon)
signal upgrades_changed(upgrades)
## organize by tag
var _upgrades : Dictionary = {}
var _upgradeCount : = 0 : 
	get():
		return _upgradeCount
	set(value):
		upgrades_changed.emit(_upgrades.duplicate())
		_upgradeCount = value
@export var weapon1 : Weapon 
var weapon2 : Weapon : 
	get():
		return weapon2
	set(value):
		weapon2_changed.emit(value)
		weapon2 = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
