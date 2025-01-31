extends Node
#Loaded globally in project settings->globals
#Enums go here

enum CHARACTER_STATE_NAMES {IDLE, WALK,DEATH}

enum UpgradeCategory{
	GLOBAL,
	WEAPON,
}

enum DamageType {
	KINETIC,
	FIRE, 
	ENERGY,
}
#enum UPGRADE_TYPE{
	#DAMAGE,
	#SPEED,
	#RANGE,
	#AOE,
	#
#}

enum Rarity {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY
}

enum PlayerNumericStatID {
	HP,
	MAX_HP,
	SPEED,
	ENERGY,
	MAX_ENERGY
}

# !!!IMPORTANT!!!
# make sure to assign an enum value to anything in WeaponPropertyStatID so that there is 
# not an ID collision with WeaponNumericStatID. This allows for function reuse
enum WeaponNumericStatID {
	WEAPON_RANGE = 200,
	FIRE_RATE = 201,
	RAW_DAMAGE = 202,
	PROJECTILE_SPEED = 203,
	PROJECTILE_COUNT = 204,
	PROJECTILE_CHAIN = 205,
	AREA_OF_EFFECT = 206,
}

static func StringToWeaponNumericStatID(str : String):
	match str:
		"weaponRange":
			return WeaponNumericStatID.WEAPON_RANGE
		"fireRate":
			return WeaponNumericStatID.WEAPON_RANGE
		"rawDamage":
			return WeaponNumericStatID.RAW_DAMAGE
		"projectileSpeed":
			return WeaponNumericStatID.PROJECTILE_SPEED
		"projectileCount":
			return WeaponNumericStatID.PROJECTILE_COUNT
		"projectileChain":
			return WeaponNumericStatID.PROJECTILE_CHAIN
		"aoe":
			return WeaponNumericStatID.AREA_OF_EFFECT
		_:
			return 0
			
# !!!IMPORTANT!!!
# make sure to assign an enum value to anything in WeaponPropertyStatID so that there is 
# not an ID collision with WeaponNumericStatID. This allows for function reuse
enum WeaponPropertyStatID {
	DAMAGE_TYPE = 100
}

enum NumericOperation {
	MULTIPLY_ADDITIVE,
	MULTIPLY_MULTIPLICATIVE,
	ADD_FLAT,
	ADD_COMPOUNDING,
}

enum WeaponSlot {
	LEFT_ARM,
	RIGHT_ARM,
	BACKPACK
}

enum WeaponType{
	NULL,
	TESLA_GUN,
	AUTO_CANNON,
	GRENADE_LAUNCHER,
}

enum CrabColor{
	YELLOW,
	BLUE,
	RED
}
