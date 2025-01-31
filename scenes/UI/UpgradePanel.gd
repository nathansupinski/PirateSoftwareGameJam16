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
	if is_instance_of(newCard.upgrade,WeaponUpgrade):
		upgrade_name.text += " (%s)" % "(left)"\
		if(newCard.upgrade as WeaponUpgrade).weaponSlot == Enums.WeaponSlot.LEFT_ARM else "(Right)"
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

func setIcon(card: UpgradeCard) -> void:
	if card.upgrade.modifier is PlayerNumericModifier:
		match card.upgrade.modifier.statID:
			Enums.PlayerNumericStatID.MAX_HP:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/healthBoost.png")
			Enums.PlayerNumericStatID.SPEED:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/speedBoost.png")
			Enums.PlayerNumericStatID.PICKUP_RADIUS:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/pickuprangeBoost.png")
	
	if card.upgrade.modifier is WeaponNumericModifier:
		match card.upgrade.modifier.statID:
			Enums.WeaponNumericStatID.WEAPON_RANGE:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/attackrangeBoost.png")
			Enums.WeaponNumericStatID.FIRE_RATE:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/firerateBoost.png")
			Enums.WeaponNumericStatID.RAW_DAMAGE:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/damageBoost.png")
			Enums.WeaponNumericStatID.PROJECTILE_SPEED:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/projectilevelocityBoost.png")
			Enums.WeaponNumericStatID.PROJECTILE_COUNT:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/multishotBoost.png")
			Enums.WeaponNumericStatID.PROJECTILE_CHAIN:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/ricochetBoost.png")
			Enums.WeaponNumericStatID.AREA_OF_EFFECT:
				texture_rect.texture = preload("res://scenes/UI/upgradeSprites/blastradiusBoost.png")
	
				


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
