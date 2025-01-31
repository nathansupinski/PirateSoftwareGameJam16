extends Timer

@onready var game_timer: Timer = %GameTimer
@onready var time_display: Label = $"../TimeDisplay"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time_display.visible = false
	game_timer.wait_time = 900 #15 minutes
	SignalBus.gameStart.connect(start_timer)
	game_timer.timeout.connect(SignalBus.gameWon.emit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_display.text = "%02d:%02d" % time_left_to_live()
	
func time_left_to_live():
	var timeLeft = game_timer.time_left
	var minute = floor(timeLeft/60)
	var second = int(timeLeft) % 60
	return [minute, second]

func start_timer():
	print("GameTimer started")
	time_display.visible = true
	game_timer.start()
