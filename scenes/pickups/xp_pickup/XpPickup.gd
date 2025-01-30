class_name XpPickup extends Pickup
const my_scene = preload("res://scenes/pickups/xp_pickup/XpPickup.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var xpValue: int = 1

static func new_xpPickup(position: Vector2, value = null) -> XpPickup:
	var new_xp: XpPickup = my_scene.instantiate()
	
	#randomize value(rarity)
	if value == null:
		var roll = randi_range(0,100)
		if roll > 90:
			value = 3
			#new_xp.get_node("Sprite2D").texture = preload("res://scenes/pickups/xp_pickup/sprites/GEM 1 - RED - Spritesheet.png")
		elif roll > 80:
			#new_xp.get_node("Sprite2D").texture = preload("res://scenes/pickups/xp_pickup/sprites/GEM 1 - PURPLE - Spritesheet.png")
			value = 2
		else:
			value = 1
	new_xp.xpValue = value
	new_xp.position = position
	new_xp.y_sort_enabled = true
	return new_xp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match xpValue:
		1:
			animation_player.play("xp_spin")
		2: 
			animation_player.play("xp_spin_green")
		3:
			animation_player.play("xp_spin_red")


func apply(player: Player) -> void:
	player.applyXp(xpValue)
	self.queue_free()
	
