extends CanvasLayer

@onready var player: Player = %Player
@onready var health_bar: ProgressBar = $MarginContainer2/VBoxContainer/HealthBar
@onready var health_text: Label = $MarginContainer2/VBoxContainer/HealthBar/HealthText
@onready var energy_bar: ProgressBar = $MarginContainer2/VBoxContainer/EnergyBar
@onready var energy_text: Label = $MarginContainer2/VBoxContainer/EnergyBar/EnergyText
@onready var upgrade_container: MarginContainer = $UpgradeContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.healthChanged.connect(UpdateHealth)
	player.energyChanged.connect(UpdateEnergy)
	SignalBus.playerUpgradesChanged.connect(UpdateUpgradeHud)
	SignalBus.weaponUpgradesChanged.connect(_onWepUpgrade)
	UpdateEnergy(player.currentHealth)
	UpdateHealth(player.currentEnergy)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func UpdateHealth(current) -> void:
	health_text.text = str(player.currentHealth) + "/" + str(player.maxHealth)
	health_bar.max_value = player.maxHealth
	health_bar.value = player.currentHealth
	SetHealthBarColor()

func SetHealthBarColor() -> void:
	if player.currentHealth <= player.maxHealth * 0.4:
		health_bar.set_theme_type_variation("HealthBarLow")
	else:
		health_bar.set_theme_type_variation("HealthBarHigh")

func UpdateEnergy(current) -> void:
	energy_text.text = str(player.currentEnergy) + "/" + str(player.maxEnergy)
	energy_bar.max_value = player.maxEnergy
	energy_bar.value = player.currentEnergy
	
func _onWepUpgrade(slot: Enums.WeaponSlot, card: UpgradeCard):
	UpdateUpgradeHud(card)
	
func UpdateUpgradeHud(card: UpgradeCard) -> void:
	print('show hud upgrade')
	var upgradeTile: UpgradeIcon = load("res://scenes/UI/UpgradeIcon.tscn").instantiate()
	upgradeTile.initialize(card)
	upgrade_container.get_child(0).add_child(upgradeTile)
