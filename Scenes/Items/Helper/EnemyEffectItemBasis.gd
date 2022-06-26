tool
extends Item
class_name EnemyAreaEffectItemBasis

export (float) var radius setget resize_radius
export (PackedScene) var effect_node
onready var effect_area:Area2D = $EffectArea
onready var coll_shape = $EffectArea/CollisionShape2D
onready var sprite = $Sprite

onready var tween_blast = $Blast
onready var blast_radius = $BlastRadius
export (float) var blast_time = 1
var blast_size:float = radius/4000 * 17

func _ready():
	._ready()
	resize_radius(radius)


func resize_radius(_radius):
	radius = _radius
	blast_size = (_radius/4000)*17
	#var coll_shape:CollisionShape2D = effect_area.get_child(0)
	if Engine.editor_hint:
		coll_shape = get_node("EffectArea/CollisionShape2D")
	if is_instance_valid(coll_shape):
		#because else the moment this gets created, the radius would be set to radius, this setter would be called and create an error, becouse the collision shape does not exists yet
		coll_shape.shape.radius = radius

func pick_up(player:Player):
	if effect_node != null:
		tween_blast.interpolate_property(blast_radius,"scale",Vector2(1,1),Vector2(blast_size,blast_size),blast_time)
		tween_blast.start()

		for child in get_children():
			if child != tween_blast and child != blast_radius:
				child.queue_free()
		for body in effect_area.get_overlapping_bodies():
			if body.is_in_group("ENEMIES"):
				var _effect = effect_node.instance()
				body.add_child(_effect)



func _on_Blast_tween_completed(object, key):
	queue_free()
