extends Weapon

const CHARGE_SOUND : AudioStreamWAV = preload("res://sound/player/player_tesla_charge.wav")
var _lastDirection
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$ChargeTimer.wait_time = weaponData.chargeTime
	$ChargeTimer.timeout.connect(fireLightning)

func fireLightning():
	super.Shoot(_lastDirection)
	print("Shooting")
	$ChargeTimer.stop()
	pass


func _process(delta: float) -> void:
	print($ChargeTimer.time_left)
func Shoot(direction: Vector2) -> void:
	_lastDirection = direction
	if (_attackTimer.is_paused() or _attackTimer.is_stopped()) and not $ChargeTimer.time_left>0:
		#print("charging")
		print("hello?")
		_lastDirection = direction
		$AudioStreamPlayer.stream = CHARGE_SOUND
		$AudioStreamPlayer.play()
		$ChargeTimer.start()

func CancelCharge():
	$ChargeTimer.stop()
