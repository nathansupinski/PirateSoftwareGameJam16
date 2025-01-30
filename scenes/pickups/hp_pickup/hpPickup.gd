class_name HpPickup extends Pickup
const my_scene = preload("res://scenes/pickups/hp_pickup/hpPickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


static func new_hpPickup(position: Vector2, value = null) -> HpPickup:
	var new_xp: HpPickup = my_scene.instantiate()
	new_xp.position = position
	return new_xp
	
func apply(player: Player) -> void:
	if player.currentHealth < player.maxHealth:
		player.playHpPickupSound()
		player.setCurrentHealth(player.maxHealth)
		self.queue_free()
