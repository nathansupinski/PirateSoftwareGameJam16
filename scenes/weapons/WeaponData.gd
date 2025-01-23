class_name WeaponData extends Resource

enum DamageType {KINETIC,FIRE, ENERGY}

## Perhaps have modifiers else where (player?) and apply them to these values
## But do not change them in the resources (preserve base stats)

@export var name : String = "null"
@export var tags : Array[String] = []
@export var range : float = 500
@export_range(0.05,2) var cooldown : float = 0.66
@export_group("damage")
@export var rawDamage : float = 50.0
@export var damageType : DamageType = DamageType.KINETIC
@export_group("projectile")
@export var projectileSpeed : float = 300
@export var projectileCount : float 
@export var projectileChain : int = 0
@export var areaOfAffect : float = 0.0 #radius





	
 
