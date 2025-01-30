extends Projectile

var time : float = 0


func _process(delta: float) -> void:
	if not visible:
		return
		

func Reset():
	self.position = Vector2.ZERO
	_traveled = 0
	_chained = 0
	$CollisionShape2D.shape.a = Vector2.ZERO
	$CollisionShape2D.shape.b = Vector2.ZERO
	await get_tree().create_timer(0.4).timeout
	self.visible = false
	
	
	$Line2D.clear_points()

func enemyHit():
	$CollisionShape2D.shape.a = $CollisionShape2D.shape.b + direction*2
	
	
#func get_real_position():
	#return $CollisionShape
func _physics_process(delta: float) -> void:
	if not visible or not source:
		return
	if _traveled > source.weaponData.weaponRange:
		projectile_destroyed.emit(self)
		
	time += delta
	
	
		
	var deltaPos = source.weaponData.projectileSpeed*direction*delta
	
	#if len($Line2D.points)  % 2 == 0:
		#deltaPos+=Vector2(-direction.x,direction.y)*randf_range(-25,25)
	#print("Delta pos: ", deltaPos)
	_traveled += deltaPos.length()
	if len($Line2D.points)  % 2 == 0:
		$Line2D.add_point($CollisionShape2D.shape.b+Vector2(-direction.x,direction.y)*randf_range(-25,25))
		time=0
	else:
		$Line2D.add_point($CollisionShape2D.shape.b)
	$CollisionShape2D.shape.b+=deltaPos
	
	#position += deltaPos
