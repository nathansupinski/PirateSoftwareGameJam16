class_name Enemy extends Character

const my_scene = preload("res://scenes/enemy/enemy.tscn")

func _init():
	super()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("init state machine " + str(stateMachine))
	stateMachine.Initialize(self)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
static func new_enemy(name: String, speed := 50.0, health := 100, maxHealth:= 100, position: Vector2 = Vector2(0,0)) -> Enemy:
	var new_enemy: Enemy = my_scene.instantiate()
	new_enemy.maxHealth = maxHealth
	new_enemy.currentHealth = health
	new_enemy.speed = speed
	new_enemy.characterName = name
	return new_enemy
