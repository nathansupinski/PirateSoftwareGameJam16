class_name Projectile extends Area2D


const CHAIN_REDUCTION = 0.8


signal projectile_destroyed(projectile)
@onready var collider: CollisionShape2D = $CollisionShape2D

var source : Weapon = null 
var direction : Vector2 = Vector2.ZERO
var _traveled : float = 0
var _chained : int = 0

func calculateDamage():
	return 0

func Reset():
	direction = Vector2.ZERO
	if "aoe" in source.weaponData.tags:
		var expl = Explosion.NewExplosion(source.weaponData.rawDamage,0.3,source.weaponData.areaOfAffect)
		call_deferred("add_child",expl)
		await expl.tree_exited
		#$Polygon2D.visible = true
		#var tween = get_tree().create_tween()
		#var before
		#tween.tween_callback(
			#func(): 
			##$MeshInstance2D.mesh.radius = $CollisionShape2D2.shape.radius/10
			#$Polygon2D.scale = Vector2($CollisionShape2D2.shape.radius,$CollisionShape2D2.shape.radius)/10
			#
			#)
		#tween.tween_property($CollisionShape2D2.shape,"radius",source.weaponData.areaOfAffect,0.5)
		#tween.tween_property($CollisionShape2D2.shape,"radius",0.01,0.1)
		#await tween.finished
		#$CollisionShape2D2.shape.radius=0.01
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
func _physics_process(delta: float) -> void:
	if not visible or not source:
		return
	if _traveled > source.weaponData.weaponRange:
		projectile_destroyed.emit(self)
		
	var deltaPos = source.weaponData.projectileSpeed*direction*delta
	#print("Delta pos: ", deltaPos)
	_traveled += deltaPos.length()
	position += deltaPos


func enemyHit():
	pass

func _on_area_entered(area):
	if area.name == "hurtBox" and is_instance_of(area.get_parent(), Enemy):
		call_deferred("enemyHit")
		#TODO: Figure out how to calculate upgrade effect on damage
		#TODO: Figure out if 'call_deferred' will take the value when set, or when actually called
		var finalDamage = source.weaponData.rawDamage
		if "chain" in source.weaponData.tags \
		and self._chained <= source.weaponData.projectileChain:
			var enemies = get_tree().get_nodes_in_group("Enemy")
			enemies.sort_custom(
			func(a,b):
				var dist1 = $CollisionShape2D.global_position.distance_to(a.global_position)
				var dist2 = $CollisionShape2D.global_position.distance_to(b.global_position)
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
			
