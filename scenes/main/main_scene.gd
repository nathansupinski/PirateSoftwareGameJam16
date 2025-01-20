extends Node2D

@onready var player = $Player
@onready var pauseMenu = $PauseMenu
@onready var enemy_container: Node2D = $EnemyContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy1 = Enemy.new_enemy('Enemy1', 50, 100, 100, Vector2(200,300))
	enemy_container.add_child(enemy1);
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		print("Paused")
		get_tree().paused = true
		pauseMenu.show()
