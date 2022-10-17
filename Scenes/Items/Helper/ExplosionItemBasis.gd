extends EnemyAreaEffectItemBasis

export (float) var damage = 100
export (float) var exp_size = 5
export (PackedScene) var explosion

func pick_up(player:Player):
	var _exp:Node2D = explosion.instance()
	_exp.damage = damage
	_exp.scale.x = exp_size
	_exp.scale.y = _exp.scale.x
	_exp.global_position = global_position
	call_deferred("_add_to_game",_exp)
	queue_free()

func _add_to_game(_exp):
	get_node("/root/Game").add_child(_exp)
