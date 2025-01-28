class_name Crab extends Enemy




static func new_enemy(player: Player, name: String, speed := 50.0, health := 100,\
 maxHealth:= 100, collisionDamage:=20, position: Vector2 = Vector2(0,0)) -> Enemy:
	var new_enemy: Enemy = Global.enemies['crab'].instantiate()
	new_enemy.player = player
	new_enemy.maxHealth = maxHealth
	new_enemy.currentHealth = health
	new_enemy.speed = speed
	new_enemy.characterName = name
	new_enemy.collisionDamage = collisionDamage
	new_enemy.position = position
	return new_enemy
