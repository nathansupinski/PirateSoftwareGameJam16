extends Node


var weapons : Dictionary = {
	"120mmCannon":{
		"left": load("res://scenes/weapons/120mmCannonLeft/120mmCannonLeft.png"),
		"right": load("res://scenes/weapons/120mmCannonRight/120mmCannonRight.png"),
	},
	"teslaGun":{
		"left": load("res://scenes/weapons/teslaGunLeft/teslaGunLeft.png"),
		"right": load("res://scenes/weapons/teslaGunRight/teslaGunRight.png"),
	},
	"40mmGrenadeLauncher":{
		"left": load("res://scenes/weapons/40mmGrenadelauncherLeft/40mmGrenadelauncherLeft.png"),
		"right": load("res://scenes/weapons/40mmGrenadelauncherRight/40mmGrenadelauncherRight.png"),
	}
}


func _ready() -> void:
	weapons.make_read_only()
