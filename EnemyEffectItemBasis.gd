extends Item
class_name EnemyAreaEffectItemBasis

export (PackedScene) var effect_node
onready var effect_area:Area2D = $EffectArea

func pick_up(player:Player):
	if effect_node != null:
		for body in effect_area.get_overlapping_bodies():
			if body.is_in_group("ENEMIES"):
				var _effect = effect_node.instance()
				body.add_child(_effect)
	queue_free()
