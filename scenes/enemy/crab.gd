class_name Crab extends Enemy




static func new_enemy(player: Player, name: String, speed := 50.0, health := 100,\
 maxHealth:= 100, collisionDamage:=20, position: Vector2 = Vector2(0,0), color: Enums.CrabColor = Enums.CrabColor.YELLOW) -> Enemy:
	var new_enemy: Enemy = Global.enemies['crab'].instantiate()
	new_enemy.player = player
	new_enemy.maxHealth = maxHealth
	new_enemy.currentHealth = health
	new_enemy.speed = speed
	new_enemy.characterName = name
	new_enemy.collisionDamage = collisionDamage
	new_enemy.position = position
	match color:
		Enums.CrabColor.YELLOW:
			new_enemy.spriteSheets = Global.crabSprites["normal"]["walk"]
			new_enemy.deathSprites = Global.crabSprites["normal"]["death"]
		Enums.CrabColor.BLUE:
			new_enemy.spriteSheets = Global.crabSprites["blue"]["walk"]
			new_enemy.deathSprites = Global.crabSprites["blue"]["death"]
		Enums.CrabColor.RED:
			new_enemy.spriteSheets = Global.crabSprites["red"]["walk"]
			new_enemy.deathSprites = Global.crabSprites["red"]["death"]
	
	return new_enemy
