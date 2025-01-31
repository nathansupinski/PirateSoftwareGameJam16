extends Node2D

@onready var player: Player = %Player
@onready var tile_map_layer: TileMapLayer = %TileMapLayer

var totalEnemies: int = 0
var mapSize = Utils.mapSize
var mapEdgeOffset = 600
var spawnBounds: Rect2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.gameStart.connect(_on_start_game)
	z_index = 100
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_game() -> void:
	print("EXPECT FALSE",Utils.check_position_is_valid_spawn_loc(Vector2(0,0)))
	
	var topLeftBounds = Utils.getValidSpawnPosition(Vector2(mapEdgeOffset,mapEdgeOffset))
	var bottomRight = Utils.getValidSpawnPosition(Vector2(mapSize - mapEdgeOffset,mapSize - mapEdgeOffset))
	spawnBounds = Rect2i(topLeftBounds, bottomRight)
	queue_redraw()
	
	spawnEnemiesInRing(Crab, 20, true)

	#spawn a wave every 10s
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.autostart = false;
	timer.wait_time = 10;
	timer.timeout.connect(spawnWave)
	timer.start()

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
		
		#clamp the spawn location to the within the bounds of the map, then check for a valid spawn
		#bounds could be wrong because the proc gen can generate water that cuts in from the corners of the bounding box
		var spawnLoc = Utils.getValidSpawnPosition(player.position + offset)

		# Spawn the instance
		self.add_child(enemyClass.new_enemy(player, 'Enemy'+str(i), 50, 100, 100, 20, spawnLoc))
	totalEnemies += numberToSpawn
	print("spawned " + str(numberToSpawn) + " enemies. (" + str(totalEnemies) + " total)")
		
func spawnWave() -> void:
	print("spawning wave")
	spawnEnemiesInRing(Crab, 50, true)
	
func clampSpawnArea(position: Vector2i) -> Vector2i:
	return Vector2i(
		clamp(position.x, spawnBounds.position.x, spawnBounds.position.x + spawnBounds.size.x - 1),
		clamp(position.y, spawnBounds.position.y, spawnBounds.position.y + spawnBounds.size.y - 1)
	)

func get_tile_data_at_position(tilemap: TileMapLayer, global_position: Vector2) -> int:
	var local_position = tilemap.to_local(global_position) # Convert to local space
	var tile_coords = tilemap.local_to_map(local_position) # Convert to tilemap coords
	
	var tileData = tilemap.get_cell_tile_data(tile_coords)
	print("get_cell_tile_data", tilemap.get_cell_tile_data(tile_coords))
	print("get_cell_source_id", tilemap.get_cell_source_id(tile_coords))
	print("tile terrain", tileData.terrain)
	return tilemap.get_cell_source_id(tile_coords) # Get tile source ID
	
func _draw() -> void:
	var rect = Rect2i(player.position, Vector2(40,40))
	draw_rect(spawnBounds, Color.RED, false, 4)
