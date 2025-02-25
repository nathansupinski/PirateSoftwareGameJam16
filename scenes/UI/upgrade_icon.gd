class_name UpgradeIcon extends Control
@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var label: Label = $MarginContainer/Label

var card: UpgradeCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('upgradeicon rdy')
	if card:
		color_rect.color = Utils.getColorForRarity(card.rarity)
		texture_rect.texture = Utils.getIconTexture(card)
		if card.upgrade.modifier is PlayerNumericModifier or card.upgrade.modifier is WeaponNumericModifier:
			label.text = str(card.upgrade.modifier.value.getValueForRarity(card.rarity))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func initialize(newCard: UpgradeCard) -> void:
	print('upgradeicon init')
	card = newCard
	if self.is_node_ready():
		color_rect.color = Utils.getColorForRarity(card.rarity)
		texture_rect.texture = Utils.getIconTexture(card)
		if card.upgrade.modifier is PlayerNumericModifier or card.upgrade.modifier is WeaponNumericModifier:
			label.text = card.upgrade.modifier.value.getValueForRarity(card.rarity)
