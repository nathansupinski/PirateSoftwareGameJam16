extends Weapon

const CHARGE_SOUND : AudioStreamWAV = preload("res://sound/player/player_tesla_charge.wav")
var _lastDirection
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$ChargeTimer.wait_time = weaponData.fireRate
	$ChargeTimer.timeout.connect(fireLightning)

func fireLightning():
	super.Shoot(_lastDirection)
	$ChargeTimer.stop()
	pass


func Shoot(direction: Vector2) -> void:
	_lastDirection = direction
	if (_attackTimer.is_paused() or _attackTimer.is_stopped()) and not $ChargeTimer.time_left>0:
		_lastDirection = direction
		$AudioStreamPlayer.stream = CHARGE_SOUND
		$AudioStreamPlayer.play()
		$ChargeTimer.start()

func CancelCharge():
	
	if $ChargeTimer.time_left > 0:
		$AudioStreamPlayer.stop()
	$ChargeTimer.stop()
