extends Node

signal playerDied(killingEntity: Character)
signal playerDamaged(damagingEntity: Character, damageTaken: int)
signal procGenDone
signal procGenChunkGenerated(chunkPosition: Vector2i)
