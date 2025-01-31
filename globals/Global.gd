extends Node


const weapons : Dictionary = {
	"120mmCannon":{
		"left": preload("res://scenes/weapons/120mmCannonLeft/120mmCannonLeft.png"),
		"right": preload("res://scenes/weapons/120mmCannonRight/120mmCannonRight.png"),
		#"scene": preload("res://scenes/weapons/120mmCannon.tscn")
	},
	"teslaGun":{
		"left": preload("res://scenes/weapons/teslaGunLeft/teslaGunLeft.png"),
		"right": preload("res://scenes/weapons/teslaGunRight/teslaGunRight.png"),
		#"scene": preload("res://scenes/weapons/teslaGun.tscn")
	},
	"40mmGrenadelauncher":{
		"left": preload("res://scenes/weapons/40mmGrenadelauncherLeft/40mmGrenadelauncherLeft.png"),
		"right": preload("res://scenes/weapons/40mmGrenadelauncherRight/40mmGrenadelauncherRight.png"),
		#"scene": preload("res://scenes/weapons/40mmGrenadelauncher.tscn"),
	}
}




const enemies : Dictionary = {
	"crab": preload("res://scenes/enemy/Crab.tscn"),
}

var selectedWeapon1 : Weapon
var selectedWeapon2 : Weapon

func GetPlayer() -> Player:
	return get_tree().get_first_node_in_group("player")
