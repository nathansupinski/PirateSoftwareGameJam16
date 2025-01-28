extends Node2D

@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var tile_map_layer_props: TileMapLayer = $"../TileMapLayerProps"
@onready var tile_map_layer_entities: TileMapLayer = $"../TileMapLayerEntities"

var chunkSize = 16
var tileSize = 64
var chunkDic = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SignalBus.procGenChunkRendered.connect(_on_chunk_loaded)
	SignalBus.procGenChunkGenerated.connect(_on_chunk_loaded)
	SignalBus.procGenChunkErased.connect(_on_chunk_unloaded)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_chunk_loaded(chunkPosition: Vector2i) -> void:
	await get_tree().process_frame
	var globalChunkPosition = chunkPosition * chunkSize * tileSize
	var globalChunkCenter = globalChunkPosition + Vector2i(chunkSize * tileSize / 2,chunkSize * tileSize / 2)
	var chunkGlobalRect = Rect2i(globalChunkPosition ,Vector2i(chunkSize * tileSize , chunkSize * tileSize))
	var globalChunkEndPosition = globalChunkPosition + Vector2i(chunkSize * tileSize - 1,chunkSize * tileSize - 1)
	var tileMapChunkCoords = tile_map_layer.local_to_map(globalChunkPosition)
	var tileMapChunkEndCoords = tile_map_layer.local_to_map(globalChunkEndPosition)
	#tile_map_layer.set_cell(tileMapChunkCoords, 6, Vector2i(3,3))
	#tile_map_layer.set_cell(tileMapChunkEndCoords, 4, Vector2i(3,3))
	
	if chunkDic.has(chunkPosition):
		var chunkEntities = chunkDic[chunkPosition].filter(func(entity): return is_instance_valid(entity))

		for entity: Node2D in chunkEntities:
			enableNode(entity)
		
		chunkDic[chunkPosition] = chunkEntities #update the dic with the pruned entities
	else:
		chunkDic[chunkPosition] = []
		var chunkEntities = chunkDic[chunkPosition]
		spawnChunkEntities(chunkEntities, globalChunkCenter)
	pass

func spawnChunkEntities(chunkEntities, globalChunkCenter: Vector2i) -> void:
	spawnHp(chunkEntities, globalChunkCenter)

func spawnHp(chunkEntities, globalChunkCenter: Vector2i) -> void:
	var roll = randf()
	if roll < .20:
		var hpPickup = HpPickup.new_hpPickup(globalChunkCenter)
		add_child(hpPickup)
		chunkEntities.append(hpPickup)
		print("hp spawned")

func _on_chunk_unloaded(chunkPosition: Vector2i) -> void:
	if chunkDic.has(chunkPosition):
		var chunkEntities = chunkDic[chunkPosition].filter(func(entity): return is_instance_valid(entity))

		for entity: Node2D in chunkEntities:
			disableNode(entity)
		
		chunkDic[chunkPosition] = chunkEntities #update the dic with the pruned entities
	
func disableNode(node: Node):
	node.set_process(false)
	node.set_physics_process(false)
	node.visible = false  # If it's a visual node like Sprite2D or Control

func enableNode(node: Node):
	node.set_process(true)
	node.set_physics_process(true)
	node.visible = true  # If it's a visual node like Sprite2D or Control
