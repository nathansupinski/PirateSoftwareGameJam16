extends CanvasLayer

@onready var upgrade_1: UpgradePanel = $HBoxContainer/MarginContainer/Upgrade1
@onready var upgrade_2: UpgradePanel = $HBoxContainer/MarginContainer2/Upgrade2
@onready var upgrade_3: UpgradePanel = $HBoxContainer/MarginContainer3/Upgrade3

var upgradeResources
var card1: UpgradeCard
var card2: UpgradeCard
var card3: UpgradeCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgradeResources = load_resources_from_folder("res://resources/upgrades")
	print("Total resources loaded: ", upgradeResources.size())
	SignalBus.playerLevelup.connect(_on_level_up)
	upgrade_1.pressed.connect(_upgrade_1_pressed)
	upgrade_2.pressed.connect(_upgrade_2_pressed)
	upgrade_3.pressed.connect(_upgrade_3_pressed)
	#RollCards()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_level_up() -> void:
	print("open upgrade menu")
	RollCards()
	visible = true
	get_tree().paused = true

func RollCards() -> void:
	card1 = generateUpgradeCard()
	card2 = generateUpgradeCard()
	card3 = generateUpgradeCard()
	upgrade_1.SetCard(card1)
	upgrade_2.SetCard(card2)
	upgrade_3.SetCard(card3)
	
	
func is_valid_card(card : UpgradeCard) -> bool:
	var p : Player = Global.GetPlayer()
	if not p:
		push_error("Couldn't find player")
		
	if is_instance_of(card.upgrade,WeaponUpgrade):
		var upgrade : WeaponUpgrade = card.upgrade
		if not upgrade.weaponTypes:
			push_error("Card %s doesn't have any weapon types assigned! " % card.name)
		for type in upgrade.weaponTypes:
			if not p.HasWeaponType(type):
				return false
	return true
		
func generateUpgradeCard() -> UpgradeCard:
	
	var upgradeIndexRoll = randi_range(0, upgradeResources.size() -1)
	while not is_valid_card(upgradeResources[upgradeIndexRoll]):
		print("try %d" % upgradeIndexRoll)
		upgradeIndexRoll = randi_range(0, upgradeResources.size() -1)
	var upgradeRarityRoll = rollUpgradeRarity()
	if upgradeResources[upgradeIndexRoll] is UpgradeCard:
		var card:UpgradeCard = upgradeResources[upgradeIndexRoll].duplicate()
		card.rarity = upgradeRarityRoll
		return card
		
	return null

func rollUpgradeRarity() -> int:
	var roll = randi_range(0,100)
	if roll > 95:
		return Enums.Rarity.LEGENDARY
	elif roll > 90:
		return Enums.Rarity.EPIC
	elif roll > 60:
		return Enums.Rarity.RARE
	elif roll > 40:
		return Enums.Rarity.UNCOMMON
	else:
		return Enums.Rarity.COMMON
		
func _upgrade_1_pressed() -> void:
	print("upgrade 1 pressed")
	StatBroker.registerUpgrade(card1)
	visible = false
	get_tree().paused = false

func _upgrade_2_pressed() -> void:
	print("upgrade 2 pressed")
	StatBroker.registerUpgrade(card2)
	visible = false
	get_tree().paused = false
	
func _upgrade_3_pressed() -> void:
	print("upgrade 3 pressed")
	StatBroker.registerUpgrade(card3)
	visible = false
	get_tree().paused = false
	
func load_resources_from_folder(folder_path: String) -> Array:
	var resources: Array = []

	var dir = DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.ends_with(".tres") or file_name.ends_with(".res"): # Filter only resources
				var resource_path = folder_path + "/" + file_name
				var resource = ResourceLoader.load(resource_path)
				if resource:
					resources.append(resource)
					print("Loaded resource: ", resource_path)
			file_name = dir.get_next()
	else:
		print("Failed to open directory: ", folder_path)

	return resources


func _on_visibility_changed() -> void:
	if not visible:
		#SignalBus.pickedUpgrade.emit()
		Engine.time_scale=0.2
		get_tree().create_tween().tween_property(Engine,"time_scale",1,0.5)
	else:
		Engine.time_scale = 1
		$AnimationPlayer.play("intro")
