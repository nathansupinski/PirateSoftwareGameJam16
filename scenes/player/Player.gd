class_name Player extends Character

@export var knockbackPower: int = 1500

#init player specific properties
func _init():
	super()
	speed = 80
	maxHealth = 100
	currentHealth = maxHealth

func _ready():
	stateMachine.Initialize(self)

func _process(delta):
	handleInput()
	
func _physics_process(delta):
	move_and_slide()
	handleCollision()

	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

func handleInput():
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		#print_debug(collider.name)

func hurtByEnemy(area):
	print("player hurt")
	currentHealth -= 1
	if currentHealth < 0:
		currentHealth = maxHealth
	healthChanged.emit(currentHealth)
	isHurt = true
	
	knockback(area.get_parent().velocity)
	effectsAnimations.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effectsAnimations.play("RESET")
	isHurt = false

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

#temp overload parent class until we get rid of placeholder animations
func UpdateAnimation(state: Enums.CHARACTER_STATE_NAMES) -> void:
	print('state:', state)
	match state:
		Enums.CHARACTER_STATE_NAMES.WALK:
			print("update to: walk_" + AnimDirection())
			animation_player.play("walk_" + AnimDirection())
		Enums.CHARACTER_STATE_NAMES.IDLE:
			print("update to: idle_" + AnimDirection())
			animation_player.play("idle_down") #temp
