class_name Equipment extends Node2D




signal weapon2_changed(weapon)

@export var weapon1 : Weapon 
@export var weapon2 : Weapon : 
	get():
		return weapon2
	set(value):
		weapon2_changed.emit(value)
		weapon2 = value



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon1.sprite.texture = Global.weapons[weapon1.weaponData.name]["left"]
	if weapon2:
		weapon2.sprite.texture = Global.weapons[weapon2.weaponData.name]["right"]
	SignalBus.weaponUpgradesChanged.connect(_on_weapon_upgrades_changed)

func _on_weapon_upgrades_changed(_a,_b):
	var brokerFn : Callable = StatBroker.transformWeaponNumeric
	var rightWepData : WeaponData = weapon1.weaponData
	var leftWepData : WeaponData = null if not weapon2 else weapon2.weaponData
	
	#for tag in rightWepData.tags
	const exclude_list = ["name","tags","shotSound"]
	var rightPropList = rightWepData.get_property_list().filter(
	func(p): 
		var name = p['name']
		return name not in WeaponData and name in rightWepData and name not in exclude_list
	)
	for p in rightPropList:
		var name = p["name"]
		var id = Enums.StringToWeaponNumericStatID(name)
		if id == 0:
			continue
		rightWepData.set(name,brokerFn.call(id,Enums.WeaponSlot.RIGHT_ARM,weapon1._baseStats.get(name)))
	
	if not leftWepData:
		return
	
	var leftPropList = leftWepData.get_property_list().filter(
	func(p): 
		var name = p['name']
		return name not in WeaponData and name in leftWepData and name not in exclude_list
	)
	for p in leftPropList:
		var name = p["name"]
		var id = Enums.StringToWeaponNumericStatID(name)
		if id == 0:
			continue
		leftWepData.set(name,brokerFn.call(id,Enums.WeaponSlot.LEFT_ARM,weapon2._baseStats.get(name)))
		
		
		
func Weapon1Type()  ->Enums.WeaponType:
	return StringToType(weapon1.weaponData.name)
func Weapon2Type()  ->Enums.WeaponType:
	if not weapon2:
		return Enums.WeaponType.NULL
	return StringToType(weapon2.weaponData.name)
	
static func TypeToString(type : Enums.WeaponType) -> String:
	match type:
		Enums.WeaponType.TESLA_GUN:
			return "teslaGun"
		Enums.WeaponType.GRENADE_LAUNCHER:
			return "40mmGrenadelauncher"
		Enums.WeaponType.AUTO_CANNON:
			return "120mmCannon"
		_:
			return "null"
static func StringToType(type : String) -> Enums.WeaponType:
	match type:
		"teslaGun":
			return Enums.WeaponType.TESLA_GUN
		"40mmGrenadelauncher":
			return Enums.WeaponType.GRENADE_LAUNCHER
		"120mmCannon":
			return Enums.WeaponType.AUTO_CANNON
		_:
			return Enums.WeaponType.NULL

func IsWeaponTypeEquipped(type : Enums.WeaponType):
	var string =TypeToString(type)
	return string !="null" and (string == weapon1.weaponData.name or \
			(weapon2 and string ==weapon2.weaponData.name))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func FireWeapon1(direction : Vector2) -> void:
	weapon1.Shoot(direction)

func CancelChargeWeapon1() -> void:
	weapon1.CancelCharge()

func FireWeapon2(direction : Vector2) -> void:
	if weapon2:
		weapon2.Shoot(direction)

func CancelChargeWeapon2() -> void:
	if weapon2:
		weapon2.CancelCharge()
