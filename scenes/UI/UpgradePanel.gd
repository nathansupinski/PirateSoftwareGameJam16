class_name UpgradePanel extends TextureButton

var card: UpgradeCard
@onready var upgrade_name: Label = %UpgradeName
@onready var color_rect: ColorRect = $ColorRect
@onready var upgrade_description: Label = %UpgradeDescription
@onready var upgrade_rarity: Label = %UpgradeRarity

#func _ready() -> void:
	#

func SetCard(newCard: UpgradeCard) -> void:
	card = newCard
	upgrade_name.text = card.name
	if card.upgrade.modifier is PlayerNumericModifier or card.upgrade.modifier is WeaponNumericModifier:
		upgrade_description.text = card.description % card.upgrade.modifier.value.getValueForRarity(card.rarity)
	elif card.upgrade.modifier is DamageTypeModifier:
		upgrade_description.text = card.description % card.upgrade.modifier.value
	upgrade_rarity.text = _getRarityName(card.rarity)
	_setColor(card.rarity)

func _setColor(rarity: Enums.Rarity):
	match rarity:
		Enums.Rarity.COMMON:
			color_rect.color = Color("959c97")
		Enums.Rarity.UNCOMMON:
			color_rect.color = Color("09ed46")
		Enums.Rarity.RARE:
			color_rect.color = Color("221be3")
		Enums.Rarity.EPIC:
			color_rect.color = Color("cb17eb")
		Enums.Rarity.LEGENDARY:
			color_rect.color = Color("e8890c")

func _getRarityName(rarity: Enums.Rarity):
	match rarity:
		Enums.Rarity.COMMON:
			return "Common"
		Enums.Rarity.UNCOMMON:
			return "Uncommon"
		Enums.Rarity.RARE:
			return "Rare"
		Enums.Rarity.EPIC:
			return "Epic"
		Enums.Rarity.LEGENDARY:
			return "Legendary"
###Temporary export for testing
#@export var upgrade : Upgrade :
	#set(value):
		#upgrade = value
		#updatePanel()
		#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	##upgrade = load("res://asssets/UpgradeTest.tres") as Upgrade
	#updatePanel()
	#pass # Replace with function body.
#
#
#func updatePanel()-> void:
	#
	#if not upgrade or not is_node_ready():
		#return
	#var name : String = "[center]%s" % upgrade.name
	#%UpgradeName.text = name
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
