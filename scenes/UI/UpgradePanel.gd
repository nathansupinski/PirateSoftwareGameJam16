class_name UpgradePanel extends TextureButton

var card: UpgradeCard
@onready var upgrade_name: Label = %UpgradeName
@onready var color_rect: ColorRect = $ColorRect
@onready var upgrade_description: Label = %UpgradeDescription
@onready var upgrade_rarity: Label = %UpgradeRarity
@onready var player: Player
@onready var weapon_name: Label = %WeaponName
@onready var texture_rect: TextureRect = $Panel/MarginContainer/VBoxContainer/TextureRect

func _ready() -> void:
	player = get_node("/root/MainScene/GameYsortLayers/Player")
	pass
	
func SetCard(newCard: UpgradeCard) -> void:
	card = newCard
	upgrade_name.text = card.name

	if card.upgrade.modifier is PlayerNumericModifier or card.upgrade.modifier is WeaponNumericModifier:
		upgrade_description.text = card.description % card.upgrade.modifier.value.getValueForRarity(card.rarity)
	elif card.upgrade.modifier is DamageTypeModifier:
		upgrade_description.text = card.description % card.upgrade.modifier.value
	upgrade_rarity.text = _getRarityName(card.rarity)
	_setColor(card.rarity)
	setIcon(newCard)
	if newCard.upgrade is WeaponUpgrade:
		if newCard.upgrade.weaponSlot == Enums.WeaponSlot.LEFT_ARM:
			weapon_name.text = player.equipment.getDisplayName(player.equipment.weapon1)
		elif newCard.upgrade.weaponSlot == Enums.WeaponSlot.RIGHT_ARM:
			weapon_name.text = player.equipment.getDisplayName(player.equipment.weapon2)
		elif newCard.upgrade.weaponSlot == Enums.WeaponSlot.BACKPACK:
			weapon_name.text = 'Backpack slot'
	else:
		weapon_name.text = ''
		

func _setColor(rarity: Enums.Rarity):
	color_rect.color = Utils.getColorForRarity(rarity)

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

func setIcon(card: UpgradeCard) -> void:
	texture_rect.texture = Utils.getIconTexture(card)

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
