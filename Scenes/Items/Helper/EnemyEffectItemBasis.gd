#tool
extends Item

class_name EnemyAreaEffectItemBasis


export (PackedScene) var effect_node
export (float) var blast_time = 1

onready var tween_blast:Tween = $Blast
onready var effect_area:Area2D = $EffectArea
onready var blast_effect:Sprite = $BlastRadius

func pick_up(player:Player):
		var blast_size = effect_area.get_child(0).shape.radius / 4000 * 17
		tween_blast.interpolate_property(blast_effect,"scale",Vector2(1,1),Vector2(blast_size,blast_size),blast_time)
		tween_blast.start()

		for child in get_children():
			if child != tween_blast and child != blast_effect:
				child.queue_free()

		for body in effect_area.get_overlapping_bodies():
			if body.is_in_group("ENEMIES"):
				add_effect(body)

func add_effect(body):
	if effect_node != null:
		var _effect = effect_node.instance()
		body.add_child(_effect)

func _on_Blast_tween_completed(object, key):
	queue_free()
