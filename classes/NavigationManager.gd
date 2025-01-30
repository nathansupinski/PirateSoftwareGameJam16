extends Node2D

var navRegions = {}
var debugNav = false # enable to turn on debug logging and visible nav mesh, need to adjust z-index on the tileset to get this to show

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.procGenDone.connect(_on_gen_finished)
	SignalBus.procGenChunkGenerated.connect(_on_gen_chunk_generated)
	SignalBus.procGenChunkErased.connect(_on_gen_chunk_erased)
	if debugNav:
		NavigationServer3D.set_debug_enabled(true)

func _on_gen_chunk_erased(chunkPosition: Vector2i):
	if navRegions.has(chunkPosition):
		var navRegion = navRegions[chunkPosition]
		navRegion.enabled = false
		if debugNav:
			print("navRegion disabled at ", chunkPosition)

func _on_gen_chunk_generated(chunkPosition: Vector2i):
	var chunkSize = 9.00
	var tileSize = 64.00
	var globalChunkPosition = chunkPosition * chunkSize * tileSize
	var chunkRect = Rect2i(globalChunkPosition, Vector2(chunkSize * tileSize,chunkSize * tileSize))
	
	if navRegions.has(chunkPosition):
		var navRegion = navRegions[chunkPosition]
		navRegion.enabled = true
		if debugNav:
			print("navRegion re-enabled at ", chunkPosition)
	else:
		createNavRegion(chunkRect, chunkPosition, globalChunkPosition)

func _on_gen_finished():
	print("proc gen first pass done.")
	
func createNavRegion(chunkRect: Rect2i, chunkPosition: Vector2i, globalChunkPosition) -> void:
	#wait for next physics frame so terrain colliders can spawn
	await get_tree().physics_frame
	
	var collisionChecker: VisibleArea2D = create_area(globalChunkPosition,Vector2(64 * 64,64 * 64))
	collisionChecker.set_collision_mask_value(1, true)
	
	if debugNav:
		print("nav collisionChecker cords", collisionChecker.position)
	
	#wait for next physics frame for collisionChecker collider to spawn
	await get_tree().physics_frame
	
	var overlaps = collisionChecker.get_overlapping_bodies()
	if debugNav:
		print("chunk nav overlaps: ", overlaps.size())
	
	var navRegion = NavigationRegion2D.new()
	add_child(navRegion)
	if debugNav:
		navRegion.z_index = 100 #draw nav nodes on top so you can see debug info above terrain

	# Create a new NavigationPolygon
	var navPolygon = NavigationPolygon.new()
	
	# Define the polygon's geometry (chunk size)
	var polygon_points = ([
		Vector2(chunkRect.position.x, chunkRect.position.y),  # Top-left
		Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y),  # Top-right
		Vector2(chunkRect.position.x + chunkRect.size.x, chunkRect.position.y + chunkRect.size.y),  # Bottom-right
		Vector2(chunkRect.position.x, chunkRect.position.y + chunkRect.size.y)  # Bottom-left
	])
	navPolygon.add_outline(polygon_points)
	navPolygon.make_polygons_from_outlines()
	
	# Set baking params on the polygon
	navPolygon.source_geometry_group_name = "navigationGroup"
	navPolygon.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_GROUPS_WITH_CHILDREN
	navPolygon.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	
	var chunkSize = 9.00
	# baking params for chunk offset TODO: figure out the correct values for baking_rect and border_size so we can set the correct agent radius
	var p_chunk_size = chunkSize * 64 # pixel chunk size. Chunk size * tile size
	var baking_bounds: Rect2 = chunkRect.grow(8)
	navPolygon.agent_radius = 0 # agent radius is an offset around all the sides of the nav region to prevent agent getting stuck on corners. have to keep this at zero so the nav mesh cunks connect until we figure out baking_rect and border_size
	#navPolygon.baking_rect = baking_bounds
	#navPolygon.border_size = p_chunk_size
	navPolygon.set_parsed_collision_mask(1) #set collision mask to layer 1
	
	# Assign the NavigationPolygon to the NavigationRegion2D
	navRegion.navigation_polygon = navPolygon
	
	#bake collisions in navmesh
	navRegion.bake_navigation_polygon(true)
	
	#store ref to baked navRegion in dictionary
	navRegions[chunkPosition] = navRegion

	if debugNav:
		print("created nav region")
	
func create_area(position: Vector2, size: Vector2) -> VisibleArea2D:
	# Create the Area2D node
	var area = VisibleArea2D.new()
	if debugNav:
		area.enableDebugDraw = true

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
