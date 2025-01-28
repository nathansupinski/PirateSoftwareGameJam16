class_name Upgrade extends Resource



class GameModifier:
	var category : Enums.UpgradeCategory
	var tags : Array[String]
	var value : float
	var property : String
	

static var upgrades : Dictionary


@export var name : String
var modifier : Modifier
