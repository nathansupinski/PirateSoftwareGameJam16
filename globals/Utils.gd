extends Node
#Loaded globally in project settings->globals
#util functions go here

var mapSize = 256 * 64
var mapEdgeOffset = 600
var spawnBounds: Rect2i

func _ready() -> void:
	SignalBus.gameStart.connect(_on_start_game)

func _on_start_game() -> void:
	print("EXPECT FALSE",Utils.check_position_is_valid_spawn_loc(Vector2(0,0)))
	
	var topLeftBounds = getValidSpawnPosition(Vector2(mapEdgeOffset,mapEdgeOffset))
	var bottomRight = getValidSpawnPosition(Vector2(mapSize - mapEdgeOffset,mapSize - mapEdgeOffset))
	spawnBounds = Rect2i(topLeftBounds, bottomRight)

func in_range(value : float,pivot : float, tolerance : float) -> bool:
	return value <= pivot+tolerance and value >= pivot-tolerance


func vec_angle_correct(radians : float) -> float:
	if radians < 0:
		radians = -(radians)
	elif radians > 0:
		radians = abs(PI-radians)+PI
	return radians

func get_tile_data_at_position(tilemap: TileMapLayer, global_position: Vector2) -> TileData:
	var local_position = tilemap.to_local(global_position) # Convert to local space
	var tile_coords = tilemap.local_to_map(local_position) # Convert to tilemap coords
	
	var tileData = tilemap.get_cell_tile_data(tile_coords)
	return tileData

func check_position_is_valid_spawn_loc(position: Vector2) -> bool:
	var tileMapLayer = get_node("/root/MainScene/GameYsortLayers/Tilemaps/TileMapLayer") #will probably error if main scene isnt active
	var tileMapWastelandProps = get_node("/root/MainScene/GameYsortLayers/Tilemaps/TileMapWastelandProps")
	var tileMapNestProps = get_node("/root/MainScene/GameYsortLayers/Tilemaps/TileMapNestProps")
	var tileMapGrasslandProps = get_node("/root/MainScene/GameYsortLayers/Tilemaps/TileMapGrasslandProps")
	var tileMapPlainsProps = get_node("/root/MainScene/GameYsortLayers/Tilemaps/TileMapPlainsProps")
	
	var mapLayerData = get_tile_data_at_position(tileMapLayer, position)
	var wastelandLayerData = get_tile_data_at_position(tileMapWastelandProps, position)
	var nestLayerData = get_tile_data_at_position(tileMapNestProps, position)
	var grasslandLayerData = get_tile_data_at_position(tileMapGrasslandProps, position)
	var plainsLayerData = get_tile_data_at_position(tileMapPlainsProps, position)
	
	if mapLayerData == null:
		return false # if there is no map layer tile loc is invalid
	
	if wastelandLayerData != null or nestLayerData != null or grasslandLayerData != null or plainsLayerData != null:
		return false #if there is tileData for any of these layers dont try to spawn there
	
	match mapLayerData.terrain:
		0:
			return false # dont spawn on water
		2:
			return false # dont spawn on wastelandUpper
		
	return true #tile must be valid

#translates 1 tiles distance towards the middle of the map
func translateTowardsMiddleMap(position: Vector2i) -> Vector2i:
	var tileSize = 64
	var mapMiddleEstimate = Vector2i(mapSize/2, mapSize/2)
	var newLoc = position + Vector2i(Vector2(position).direction_to(mapMiddleEstimate) * tileSize)
	
	return newLoc

func getValidSpawnPosition(position: Vector2i) -> Vector2i:
	var maxDepth = 60
	var depth = 0
	var curPos = position
	while(not check_position_is_valid_spawn_loc(curPos) and depth <= maxDepth):
		depth += 1
		curPos = translateTowardsMiddleMap(curPos)
	
	if(depth == 31):
		print("FAILED TO FIND VALID SPAWN")
	#else:
		#print("Found spawn loc in " + str(depth) + " attmeps.")
		
	return curPos
	
func clampSpawnArea(position: Vector2i) -> Vector2i:
	return Vector2i(
		clamp(position.x, spawnBounds.position.x, spawnBounds.position.x + spawnBounds.size.x - 1),
		clamp(position.y, spawnBounds.position.y, spawnBounds.position.y + spawnBounds.size.y - 1)
)
	
