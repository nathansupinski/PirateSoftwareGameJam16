class_name Projectile extends Area2D


##If we need to change how projectiles are handled on death.
##For now, just destroy projectile
## NOT IN USE
static var OnDestroy : Callable = func(projectile : Projectile) -> void:
	projectile.queue_free()



signal projectile_destroyed(projectile)
@onready var collider: CollisionShape2D = $CollisionShape2D

var source : Weapon = null 
var direction : Vector2 = Vector2.ZERO
var _traveled : float = 0
var _chained : int = 0

func Reset():
	self.visible = false
	self.position = Vector2.ZERO
	_traveled = 0
	_chained = 0
	
#@onready var sprite : Sprite2D = $Sprite2D
func _ready() -> void:
	connect("area_entered",_on_area_entered)

func _exit_tree() -> void:
	#print(self, " Destroyed")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not visible or not source:
		return
	if _traveled > source.weaponData.weaponRange:
		projectile_destroyed.emit(self)
		
	var deltaPos = source.weaponData.projectileSpeed*direction*delta
	#print("Delta pos: ", deltaPos)
	_traveled += deltaPos.length()
	position += deltaPos



func _on_area_entered(area):
	if area.name == "hurtBox" and area.get_parent() is Enemy:
		#TODO: Figure out how to calculate upgrade effect on damage
		#TODO: Figure out if 'call_deferred' will take the value when set, or when actually called
		var finalDamage = source.weaponData.rawDamage
		if source.weaponData.projectileChain > 0 \
		and self._chained <= source.weaponData.projectileChain:
			var enemies = get_tree().get_nodes_in_group("Enemy")
			enemies.sort_custom(
			func(a,b):
				var dist1 = self.global_position.distance_to(a.global_position)
				var dist2 = self.global_position.distance_to(b.global_position)
				return dist1 < dist2
				)
			if enemies.size() < 2:
				print("No other enemy")
			else:
				self.direction = self.global_position.direction_to(enemies[1].global_position)
				_chained+=1
				finalDamage = (finalDamage*(pow(0.8,_chained))) ## temporary?
		else:
			projectile_destroyed.emit(self)
		area.get_parent().dealDamage(finalDamage)
			
