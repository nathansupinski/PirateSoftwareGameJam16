class_name ProjectileContainer extends Node


func ClearPlayerProjectiles():
	$PlayerProjectiles.queue_free()
