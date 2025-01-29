class_name Explosion extends Node2D

const scene = preload("res://scenes/weapons/projectiles/Explosion.tscn")

@export var damage : float = 0
@export var lifetime = 0.5
@export_range(0,1000) var aoe : float= 0
@onready var growth_rate : float  = aoe/lifetime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#get_tree().create_timer(lifetime).timeout.connect(func():call_deferred("queue_free"))
	get_tree().create_timer(lifetime).timeout.connect(queue_free)
	$CollisionShape2D.shape.radius = aoe
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Polygon2D.scale += Vector2(growth_rate,growth_rate)*delta*0.1


func _on_area_entered(area: Area2D) -> void:
	if is_instance_of(area.get_parent(),Enemy):
		(area.get_parent() as Enemy).dealDamage(damage) # Replace with function body.


static func NewExplosion(explDamage : float, explLifetime : float, explAoe : float) -> Explosion:
	var obj = scene.instantiate()
	obj.damage = explDamage
	obj.lifetime = explLifetime
	obj.aoe = explAoe
	return obj
