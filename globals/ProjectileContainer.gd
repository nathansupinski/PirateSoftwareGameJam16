extends Node


func ClearPlayerProjectiles():
	for node in $PlayerProjectiles.get_children():
		node.queue_free()

func _ready():
	SignalBus.playerDied.connect(
		func(obj):
			ClearPlayerProjectiles()
			ClearEnemyProjectiles()
	)


func ClearEnemyProjectiles():
	for node in $EnemyProjectiles.get_children():
		node.queue_free()


func AddToPlayerProjectiles(projectile : Projectile):
	$PlayerProjectiles.add_child(projectile)
