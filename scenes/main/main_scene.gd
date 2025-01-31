extends Node2D

@onready var player = %Player
@onready var pauseMenu = $PauseMenu
@onready var enemy_container: Node2D = %EnemyContainer
@onready var death_screen: CanvasLayer = $DeathScreen
@onready var level_music_player: AudioStreamPlayer = $LevelMusicPlayer
@onready var enemy_died_player_2d: AudioStreamPlayer = $EnemyDiedPlayer2D
@onready var death_music_player: AudioStreamPlayer = $DeathMusicPlayer

const BUG_SPLAT_SOUNDS = [
	preload("res://sound/enemies/bug_splat_1.wav"),
	preload("res://sound/enemies/bug_splat_2.wav"),
	preload("res://sound/enemies/bug_splat_3.wav")
]


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	level_music_player.play()

	SignalBus.playerDied.connect(_on_player_died)
	SignalBus.playerDamaged.connect(_on_player_damaged)
	SignalBus.enemyDied.connect(_on_enemy_died)
	
	var mapPixelSize = 256 * 64 #world size in NoiseGenerator * tile size
	#player.position = Vector2i(mapPixelSize/2, mapPixelSize/2) #place player in the center of the world TODO: check for anything in the way and translate
	player.position = Vector2i(1200, 1200)
	
	SignalBus.gameStart.connect(_on_start_game)
	pass

func _on_start_game() -> void:
	pass

# Called every frame. 'delta' is the elapswed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause"):
		print("Paused")
		get_tree().paused = true
		pauseMenu.show()
		
func _on_player_died(killingEntity: Character):
	level_music_player.stop()
	death_music_player.play()
	print("Player died to " + killingEntity.characterName)
	get_tree().paused = true
	death_screen.show()

func _on_player_damaged(damagingEntity: Character, damageTaken: int):
	print("player damaged by: " +str(damagingEntity.characterName) + " (" + str(damageTaken) + " damage)")
	
func _on_enemy_died(enemyPosition: Vector2i) -> void:
	var soundIndex = randi_range(0,2)
	enemy_died_player_2d.stream = BUG_SPLAT_SOUNDS[soundIndex]
	enemy_died_player_2d.play() #TODO: make this use AudioStreamPlayer2D for positional audio 
