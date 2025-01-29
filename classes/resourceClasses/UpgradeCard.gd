class_name UpgradeCard extends Resource

@export var name: String
@export var description: String
@export var icon: Texture2D
@export var upgrade: BaseUpgrade
var rarity: Enums.Rarity = Enums.Rarity.COMMON # will be randomized when cards are generated
