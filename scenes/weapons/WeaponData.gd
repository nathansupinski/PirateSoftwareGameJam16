class_name WeaponData extends Resource



##Arbitrary max projectile count
const MAX_PROJECTILE_COUNT = 10
#If we have melee weapons, then change to 0
const MIN_PROJECTILE_COUNT = 1
## Perhaps have modifiers else where (player?) and apply them to these values
## But do not change them in the resources (preserve base stats)

@export var name : String = "null"
@export var tags : Array[String] = []
@export var weaponRange : float = 500
@export var shotSound : AudioStreamWAV
@export_range(0.05,2) var fireRate : float = 0.66
@export_group("damage")
@export var rawDamage : float = 50.0
@export var damageType : Enums.DamageType = Enums.DamageType.KINETIC
@export_group("projectile")
@export var projectileSpeed : float = 300
@export_range(MIN_PROJECTILE_COUNT,MAX_PROJECTILE_COUNT) var projectileCount : int = 1 :
	get():
		return projectileCount
	set(value):
		if value > MAX_PROJECTILE_COUNT or value < MIN_PROJECTILE_COUNT :
			return
		projectileCount = value
		
@export var projectileChain : int = 0
@export_group("misc")
@export var areaOfAffect : float = 0.0 #radius
@export var chargeTime : float = 0.0
