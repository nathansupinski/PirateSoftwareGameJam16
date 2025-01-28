extends Node2D

@onready var player = $Player
@onready var pauseMenu = $PauseMenu
@onready var enemy_container: Node2D = $EnemyContainer
@onready var death_screen: CanvasLayer = $DeathScreen

var totalEnemies: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	
	#TODO: abstract all spawning code into a wave manager or something
	#spawn starting wave
	spawnEnemiesInRing(Crab, 20, true)

	#spawn a wave every 10s
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.autostart = false;
	timer.wait_time = 10;
	timer.timeout.connect(spawnWave)
	timer.start()
	
	var test = get_world_2d()
	SignalBus.playerDied.connect(_on_player_died)
	SignalBus.playerDamaged.connect(_on_player_damaged)
	pass

# Called every frame. 'delta' is the elapswed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		print("Paused")
		get_tree().paused = true
		pauseMenu.show()
		
func _on_player_died(killingEntity: Character):
	print("Player died to " + killingEntity.characterName)
	get_tree().paused = true
	death_screen.show()

func _on_player_damaged(damagingEntity: Character, damageTaken: int):
	print("player damaged by: " +str(damagingEntity.characterName) + " (" + str(damageTaken) + " damage)")
	
func spawnEnemiesInRing(enemyClass: Script, numberToSpawn: int, randomizeOffsets: bool) -> void:
	var radius = 600
	for i in range(0, numberToSpawn):
		# Calculate the angle for this instance
		var angle = 2 * PI * i / numberToSpawn

		# Calculate the position offset
		var offset = Vector2(cos(angle), sin(angle)) * radius
		# Randomize offset
		if randomizeOffsets:
			offset = offset + Vector2(randi_range(-100,100),randi_range(-100,100))
		
		var spawnLoc = player.position + offset
		

		# Spawn the instance
		enemy_container.add_child(enemyClass.new_enemy(player, 'Enemy'+str(i), 50, 100, 100, 20, spawnLoc))
	totalEnemies += numberToSpawn
	print("spawned " + str(numberToSpawn) + " enemies. (" + str(totalEnemies) + " total)")
		
func spawnWave() -> void:
	print("spawning wave")
	spawnEnemiesInRing(Crab, 50, true)
