extends Node2D

@onready var heartsContainer = $CanvasLayer/heartsContainer
@onready var player = $Player
@onready var pauseMenu = $PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	#heartsContainer.setMaxHearts(player.maxHealth)
	#heartsContainer.updateHearts(player.currentHealth)
	#player.healthChanged.connect(heartsContainer.updateHearts)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		print("Paused")
		get_tree().paused = true
		pauseMenu.show()
