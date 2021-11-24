extends Item

export (PackedScene) var effect_node

func pick_up(player:Player):
	var _effect = effect_node.instance()
	player.add_child(_effect)
	queue_free()
