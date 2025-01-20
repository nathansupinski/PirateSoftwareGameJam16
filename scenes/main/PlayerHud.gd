extends CanvasLayer

@onready var health_bar: Label = $HealthBar
@onready var player: Player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.healthChanged.connect(UpdateHealth)
	health_bar.text = str(player.currentHealth)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func UpdateHealth(event) -> void:
	health_bar.text = str(event)
