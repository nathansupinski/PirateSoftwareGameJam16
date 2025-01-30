extends Node

#player state signals
signal playerDied(killingEntity: Character)
signal playerDamaged(damagingEntity: Character, damageTaken: int)
signal playerLevelup
signal pickedUpgrade()

#proc gen signals
signal procGenDone
signal procGenFirstChunkLoadDone
signal procGenChunkGenerated(chunkPosition: Vector2i)
signal procGenChunkErased(chunkPosition: Vector2i)
signal procGenChunkRendered(chunkPosition: Vector2i)

#stat broker signals
signal playerUpgradesChanged
signal weaponUpgradesChanged

#enemy state signals
signal enemyDied(enemyPosition: Vector2i)
