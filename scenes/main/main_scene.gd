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
	spawnEnemiesInRing(Enemy, 20, true)

	#spawn a wave every 10s
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.autostart = false;
	timer.wait_time = 10;
	timer.timeout.connect(spawnWave)
	timer.start()
	
	
	SignalBus.playerDied.connect(_on_player_died)
	SignalBus.playerDamaged.connect(_on_player_damaged)
	SignalBus.procGenDone.connect(_on_gen_finished)
	SignalBus.procGenChunkGenerated.connect(_on_gen_chunk_generated)
	pass

func _on_gen_chunk_generated(chunkPosition: Vector2i):
	print("chunk created at ", chunkPosition * 16)
	#print("chunk rect at ", Rect2i(chunkPosition * 556, 256))

func _on_gen_finished():
	print("proc gen done. Baking nav mesh...")
	var nav_region = NavigationRegion2D.new()
	add_child(nav_region)

	# Create a new NavigationPolygon
	var nav_polygon = NavigationPolygon.new()

	# Define the polygon's geometry (example shape)
	var polygon_points = PackedVector2Array([
		Vector2(0, 0),
		Vector2(4096, 0),
		Vector2(4096, 4096),
		Vector2(0, 4096)
	])
	nav_polygon.add_outline(polygon_points)
	nav_polygon.make_polygons_from_outlines()

	# Assign the NavigationPolygon to the NavigationRegion2D
	nav_region.navigation_polygon = nav_polygon
	NavigationServer3D.set_debug_enabled(true)
	print("nav mesh done.")

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
	spawnEnemiesInRing(Enemy, 50, true)
