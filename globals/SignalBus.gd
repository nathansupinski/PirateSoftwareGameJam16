extends Node

signal playerDied(killingEntity: Character)
signal playerDamaged(damagingEntity: Character, damageTaken: int)
signal procGenDone
signal procGenChunkGenerated(chunkPosition: Vector2i)
signal procGenChunkErased(chunkPosition: Vector2i)
signal procGenChunkRendered(chunkPosition: Vector2i)
