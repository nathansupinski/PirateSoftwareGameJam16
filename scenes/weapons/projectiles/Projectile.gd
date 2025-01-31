class_name Projectile extends Area2D


const CHAIN_REDUCTION = 0.8


signal projectile_destroyed(projectile)
@onready var collider: CollisionShape2D = $CollisionShape2D
var explosion_player: AudioStreamPlayer

var source : Weapon = null 
var direction : Vector2 = Vector2.ZERO
var _traveled : float = 0
var _chained : int = 0

var destroyed : bool = false

func calculateDamage():
	return 0

func Reset():
	direction = Vector2.ZERO
	if "aoe" in source.weaponData.tags and source.weaponData.areaOfAffect >0:
		var expl = Explosion.NewExplosion(source.weaponData.rawDamage,0.3,source.weaponData.areaOfAffect)
		
		#call_deferred("add_child",expl)
		expl.global_position = self.global_position
		ProjectileContainer.AddToPlayerProjectiles(expl)
	self.visible = false
	self.position = Vector2.ZERO
	_traveled = 0
	_chained = 0
	
	

#@onready var sprite : Sprite2D = $Sprite2D
func _ready() -> void:
	connect("area_entered",_on_area_entered)
	explosion_player = get_node("/root/ProjectileContainer/ExplosionPlayer")

func _exit_tree() -> void:
	#print(self, " Destroyed")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not visible or not source :
		return
	
		
	rotation = direction.angle()

	var deltaPos = source.weaponData.projectileSpeed*direction*delta
	#print("Delta pos: ", deltaPos)
	_traveled += deltaPos.length()
	position += deltaPos
	if _traveled > source.weaponData.weaponRange:
		projectile_destroyed.emit(self)
		destroyed = true


func enemyHit():
	pass

func _on_area_entered(area):
	if area.name == "hurtBox" and is_instance_of(area.get_parent(), Enemy):
		call_deferred("enemyHit")
		#TODO: Figure out how to calculate upgrade effect on damage
		#TODO: Figure out if 'call_deferred' will take the value when set, or when actually called
		var finalDamage = source.weaponData.rawDamage
		if "chain" in source.weaponData.tags \
		and self._chained < source.weaponData.projectileChain:
			var enemies = get_tree().get_nodes_in_group("Enemy")
			enemies.sort_custom(
			func(a,b):
				var dist1 = area.global_position.distance_to(a.global_position)
				var dist2 = area.global_position.distance_to(b.global_position)
				return dist1 < dist2
				)
			if enemies.size() < 2:
				print("No other enemy")
			else:
				self.direction = $CollisionShape2D.global_position.direction_to(enemies[1].global_position)
				_chained+=1
				finalDamage = (finalDamage*(pow(CHAIN_REDUCTION,_chained))) ## temporary?
		else:
			projectile_destroyed.emit(self)
		
		area.get_parent().dealDamage(finalDamage)
			
