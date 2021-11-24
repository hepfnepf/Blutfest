extends Item
class_name EffectItemBasis

export (PackedScene) var effect_node

func pick_up(player:Player):
	if effect_node != null:
		var _effect = effect_node.instance()
		player.add_child(_effect)
	queue_free()
