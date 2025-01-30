extends Node


const weapons : Dictionary = {
	"120mmCannon":{
		"left": preload("res://scenes/weapons/120mmCannonLeft/120mmCannonLeft.png"),
		"right": preload("res://scenes/weapons/120mmCannonRight/120mmCannonRight.png"),
	},
	"teslaGun":{
		"left": preload("res://scenes/weapons/teslaGunLeft/teslaGunLeft.png"),
		"right": preload("res://scenes/weapons/teslaGunRight/teslaGunRight.png"),
	},
	"40mmGrenadelauncher":{
		"left": preload("res://scenes/weapons/40mmGrenadelauncherLeft/40mmGrenadelauncherLeft.png"),
		"right": preload("res://scenes/weapons/40mmGrenadelauncherRight/40mmGrenadelauncherRight.png"),
	}
}


const enemies : Dictionary = {
	"crab": preload("res://scenes/enemy/Crab.tscn"),
}


func GetPlayer() -> Player:
	return get_tree().get_first_node_in_group("player")
