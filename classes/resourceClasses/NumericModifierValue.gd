class_name NumericModifierValue extends Resource

@export var comon_value: float = 1
@export var uncomon_value: float = 1
@export var rare_value: float = 1
@export var epic_value: float = 1
@export var legendary_value: float = 1

func getValueForRarity(rarity: Enums.Rarity) -> float:
	match rarity:
		Enums.Rarity.COMMON:
			return comon_value
		Enums.Rarity.UNCOMMON:
			return uncomon_value
		Enums.Rarity.RARE:
			return rare_value
		Enums.Rarity.EPIC:
			return epic_value
		Enums.Rarity.LEGENDARY:
			return legendary_value
	return comon_value
