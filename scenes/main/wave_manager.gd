extends Node2D

@onready var player: Player = %Player
@onready var tile_map_layer: TileMapLayer = %TileMapLayer
@onready var game_timer: Timer = %GameTimer

var totalEnemies: int = 0
var mapSize = Utils.mapSize
var mapEdgeOffset = Utils.mapEdgeOffset
var spawnBounds: Rect2i
var waveTimer : Timer

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
	
	spawnEnemiesInRing(20,Enums.CrabColor.YELLOW, 100, 50, 20)

	#spawn a wave every 10s
	waveTimer= Timer.new()
	add_child(waveTimer)
	waveTimer.autostart = false;
	waveTimer.wait_time = 10;
	waveTimer.timeout.connect(spawnWave)
	waveTimer.start()
	
func spawnWave() -> void:
	var timeLeft = game_timer.time_left
	var minute = int(floor(timeLeft/60))
	print("GAME TIME MINUTE", minute)
	match minute:
		14:
			spawnEnemiesInRing(30,Enums.CrabColor.YELLOW, 100, 50, 20)
		13:
			spawnEnemiesInRing(28,Enums.CrabColor.YELLOW, 100, 50, 20)
			spawnEnemiesInRing(2,Enums.CrabColor.BLUE, 150, 65, 25)
		12:
			spawnEnemiesInRing(25,Enums.CrabColor.YELLOW, 100, 50, 20)
			spawnEnemiesInRing(5,Enums.CrabColor.BLUE, 150, 65, 25)
		11:
			spawnEnemiesInRing(20,Enums.CrabColor.YELLOW, 100, 50, 20)
			spawnEnemiesInRing(10,Enums.CrabColor.BLUE, 150, 65, 25)
		10:
			spawnEnemiesInRing(10,Enums.CrabColor.YELLOW, 120, 50, 20)
			spawnEnemiesInRing(20,Enums.CrabColor.BLUE, 150, 65, 25)
		9:
			spawnEnemiesInRing(5,Enums.CrabColor.YELLOW, 120, 50, 20)
			spawnEnemiesInRing(25,Enums.CrabColor.BLUE, 150, 65, 25)
		8:
			spawnEnemiesInRing(30,Enums.CrabColor.BLUE, 150, 65, 25)
		7:
			spawnEnemiesInRing(30,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(2,Enums.CrabColor.RED, 200, 100, 30)
		6:
			spawnEnemiesInRing(28,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(4,Enums.CrabColor.RED, 200, 100, 30)
		5:
			spawnEnemiesInRing(25,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(5,Enums.CrabColor.RED, 200, 100, 30)
		4:
			spawnEnemiesInRing(20,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(10,Enums.CrabColor.RED, 200, 100, 30)
		3:
			spawnEnemiesInRing(15,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(15,Enums.CrabColor.RED, 200, 100, 30)
		2:
			spawnEnemiesInRing(10,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(20,Enums.CrabColor.RED, 200, 100, 30)
		1:
			spawnEnemiesInRing(30,Enums.CrabColor.RED, 200, 100, 30)
		0:
			spawnEnemiesInRing(30,Enums.CrabColor.YELLOW, 120, 50, 20)
			spawnEnemiesInRing(30,Enums.CrabColor.BLUE, 150, 65, 25)
			spawnEnemiesInRing(30,Enums.CrabColor.RED, 200, 100, 30)
		_: #base case
			print("SPAWNED BASE CASE WTF?")
			spawnEnemiesInRing(50,Enums.CrabColor.YELLOW, 100, 50, 20)
	

func spawnEnemiesInRing(numberToSpawn: int, color: Enums.CrabColor, crabHp: int, crabSpeed:int, crabDamage:int) -> void:
	var radius = 900
	for i in range(0, numberToSpawn):
		# Calculate the angle for this instance
		var angle = 2 * PI * i / numberToSpawn

		# Calculate the position offset
		var offset = Vector2(cos(angle), sin(angle)) * radius
		
		# Randomize offset
		offset = offset + Vector2(randi_range(-100,100),randi_range(-100,100))
		
		#clamp the spawn location to the within the bounds of the map, then check for a valid spawn
		#bounds could be wrong because the proc gen can generate water that cuts in from the corners of the bounding box
		var spawnLoc = Utils.getValidSpawnPosition(player.position + offset)

		# Spawn the instance. speed-hp-maxhp-damage
		self.add_child(Crab.new_enemy(player, 'Enemy'+str(i), crabSpeed, crabHp, crabHp, crabDamage, spawnLoc, color))
	totalEnemies += numberToSpawn
	print("spawned " + str(numberToSpawn) + " enemies. (" + str(totalEnemies) + " total)")
	

	
#func _draw() -> void:
	#draw_rect(spawnBounds, Color.RED, false, 4)
