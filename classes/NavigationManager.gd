extends Node2D

var navRegions = {}
@onready var game_tile_map_layers: Node2D = $"../GameTileMapLayers"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.procGenDone.connect(_on_gen_finished)
	SignalBus.procGenChunkGenerated.connect(_on_gen_chunk_generated)
	#SignalBus.procGenChunkRendered.connect(_on_gen_chunk_generated)
	SignalBus.procGenChunkErased.connect(_on_gen_chunk_erased)
	NavigationServer3D.set_debug_enabled(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Returns the global position of the cell at the given [param map_position].
func map_to_global(map_position: Vector2i) -> Vector2:
	return Vector2(map_position * 16)
	
func createNavRegion(chunkRect: Rect2i, chunkPosition: Vector2i) -> void:
	var callback_parsing: Callable
	var callback_baking: Callable
	var navigation_mesh: NavigationPolygon
	var source_geometry: NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()
	var region_rid: RID
	
	
	# We grow the chunk bounding box to include geometry
	# from all the neighbor chunks so edges can align.
	# The border size is the same value as our grow amount so
	# the final navigation mesh ends up with the intended chunk size.
	var p_chunk_size = 16 * 16 #pixel chunk size. Chunk size * tile size
	var baking_bounds: Rect2 = chunkRect.grow(p_chunk_size)
	
	navigation_mesh = NavigationPolygon.new()
	navigation_mesh.agent_radius = 10.0
	navigation_mesh.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	navigation_mesh.baking_rect = baking_bounds
	navigation_mesh.border_size = p_chunk_size

	region_rid = NavigationServer2D.region_create()

	

	var on_baking_done = func on_baking_done() -> void:
		print("in on baking done")
		# Update the region with the updated navigation mesh.
		NavigationServer2D.region_set_navigation_polygon(region_rid, navigation_mesh)
		navRegions[chunkPosition] = region_rid
		print(navRegions[chunkPosition])
		print("nav mesh bake done.")	
	
	callback_baking = on_baking_done
	
	var on_parsing_done = func on_parsing_done() -> void:
		print("in on_parsing_done")
		# If we did not parse a TileMap with navigation mesh cells we may now only
		# have obstruction outlines so add at least one traversable outline
		# so the obstructions outlines have something to "cut" into.
		source_geometry.add_traversable_outline(PackedVector2Array([
			Vector2(chunkRect.position.x, chunkRect.position.y),  # Top-left
			Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y),  # Top-right
			Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y + chunkRect.size.y),  # Bottom-right
			Vector2(chunkRect.position.x, chunkRect.position.y + chunkRect.size.y)
		]))

		# Bake the navigation mesh on a thread with the source geometry data.
		NavigationServer2D.bake_from_source_geometry_data_async(
			navigation_mesh,
			source_geometry,
			callback_baking
		)
		
	callback_parsing = on_parsing_done
	
	var parse_source_geometry = func parse_source_geometry() -> void:
		print("in parse source ")
		source_geometry.clear()
		#var root_node: Node2D = self

		# Parse the obstruction outlines from all child nodes of the root node by default.
		NavigationServer2D.parse_source_geometry_data(
			navigation_mesh,
			source_geometry,
			game_tile_map_layers,
			callback_parsing
		)
		
	# Enable the region and set it to the default navigation map.
	NavigationServer2D.region_set_enabled(region_rid, true)
	NavigationServer2D.region_set_map(region_rid, get_world_2d().get_navigation_map())
	
	print("parse source geometry")
	parse_source_geometry.call_deferred()


func _on_gen_chunk_erased(chunkPosition: Vector2i):
	print("chunk erased at ", chunkPosition)
	
	if navRegions.has(chunkPosition):
		var navRegionRID = navRegions[chunkPosition]
		navRegionRID.enabled = false
		#NavigationServer2D.region_set_enabled(navRegionRID, false)
		print("navRegion disabled at ", chunkPosition)
	pass

func _on_gen_chunk_generated(chunkPosition: Vector2i):
	var chunkSize = 16.00
	var tileSize = 16.00
	var globalChunkPosition = chunkPosition * chunkSize * tileSize
	var chunkRect = Rect2i(globalChunkPosition, Vector2(chunkSize * tileSize,chunkSize * tileSize))
	#print("chunk created at ", chunkPosition * chunkSize * tileSize)
	#print("chunk rect at ", chunkRect)
	if navRegions.has(chunkPosition):
		var navRegionRID = navRegions[chunkPosition]
		navRegionRID.enabled = true
		#NavigationServer2D.region_set_enabled(navRegionRID, true)
		print("navRegion re-enabled at ", chunkPosition)
	else:
		#createNavRegion(chunkRect, chunkPosition)
		#createRegion(chunkRect, chunkPosition)
		#oldCreateRegion(chunkRect, chunkPosition, globalChunkPosition)
		(func():oldCreateRegion(chunkRect, chunkPosition, globalChunkPosition)).call_deferred()
		print("chunk nav region created")

func _on_gen_finished():
	print("proc gen first pass done.")
	
func createRegion(chunkRect: Rect2i, chunkPosition: Vector2i):
	var callback_parsing: Callable
	var callback_baking: Callable
	var navigation_mesh: NavigationPolygon
	var source_geometry: NavigationMeshSourceGeometryData2D = NavigationMeshSourceGeometryData2D.new()
	var region_rid: RID
	navigation_mesh = NavigationPolygon.new()
	navigation_mesh.agent_radius = 10.0
	region_rid = NavigationServer2D.region_create()
	
	NavigationServer2D.region_set_enabled(region_rid, true)
	NavigationServer2D.region_set_map(region_rid, get_world_2d().get_navigation_map())

	# Add vertices for a convex polygon.
	navigation_mesh.vertices = PackedVector2Array([
		Vector2(chunkRect.position.x, chunkRect.position.y),  # Top-left
		Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y),  # Top-right
		Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y + chunkRect.size.y),  # Bottom-right
		Vector2(chunkRect.position.x, chunkRect.position.y + chunkRect.size.y)  # Bottom-left
	])

	# Add indices for the polygon.
	navigation_mesh.add_polygon(
		PackedInt32Array([0, 1, 2, 3])
	)
	
	NavigationServer2D.region_set_navigation_polygon(region_rid, navigation_mesh)
	navRegions[chunkPosition] = region_rid
	print("Nav region created")
	
	
func oldCreateRegion(chunkRect: Rect2i, chunkPosition: Vector2i, globalChunkPosition) -> void:
	await get_tree().physics_frame

	var collisionChecker: VisibleArea2D = create_area(globalChunkPosition,Vector2(16 * 16,16 * 16))
	print("area cords", collisionChecker.position)
	collisionChecker.set_collision_mask_value(1, true)
	await get_tree().physics_frame
	var overlaps = collisionChecker.get_overlapping_bodies()
	collisionChecker.body_entered.connect(func(body):
		pass 
		#print("body entered", body)
		#print("bodies: ", collisionChecker.get_overlapping_bodies().size())
	)
	
	print("overlaps: ", overlaps.size())
	
	var navRegion = NavigationRegion2D.new()
	add_child(navRegion)

	# Create a new NavigationPolygon
	var navPolygon = NavigationPolygon.new()
	# Define the polygon's geometry (example shape)
	var polygon_points = ([
		Vector2(chunkRect.position.x, chunkRect.position.y),  # Top-left
		Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y),  # Top-right
		Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y + chunkRect.size.y),  # Bottom-right
		Vector2(chunkRect.position.x, chunkRect.position.y + chunkRect.size.y)  # Bottom-left
	])
	navPolygon.add_outline(polygon_points)
	navPolygon.make_polygons_from_outlines()
	navPolygon.agent_radius = 0
	navRegion.z_index = 100
	# Assign the NavigationPolygon to the NavigationRegion2D
	navRegion.navigation_polygon = navPolygon
	navPolygon.source_geometry_group_name = "navigationGroup"
	navPolygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	navPolygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	var p_chunk_size = 16 * 16 #pixel chunk size. Chunk size * tile size
	var baking_bounds: Rect2 = chunkRect.grow(16)
	#navPolygon.baking_rect = baking_bounds
	#navPolygon.border_size = p_chunk_size
	navPolygon.set_parsed_collision_mask(1)
	
	#for node in overlaps:
		#navRegion.add_child(node)
	navRegion.bake_navigation_polygon(true)
	navRegions[chunkPosition] = navRegion
	print("created nav region")
	
func create_area(position: Vector2, size: Vector2) -> VisibleArea2D:
	# Create the Area2D node
	var area = VisibleArea2D.new()

	# Set the position of the Area2D
	area.position = position

	# Add a CollisionShape2D as a child of the Area2D
	var collision_shape = CollisionShape2D.new()
	area.add_child(collision_shape)

	# Create a RectangleShape2D to define the collision area
	var shape = RectangleShape2D.new()
	shape.size = size
	collision_shape.shape = shape

	# Add the new Area2D to the scene tree
	add_child(area)

	return area
