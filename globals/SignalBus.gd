extends Node

signal playerDied(killingEntity: Character)
signal playerDamaged(damagingEntity: Character, damageTaken: int)
signal playerLevelup
signal procGenDone
signal procGenFirstChunkLoadDone
signal procGenChunkGenerated(chunkPosition: Vector2i)
signal procGenChunkErased(chunkPosition: Vector2i)
signal procGenChunkRendered(chunkPosition: Vector2i)

#stat broker signals
signal playerUpgradesChanged
signal weaponUpgradesChanged
