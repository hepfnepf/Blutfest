extends EnemyAreaEffectItemBasis

export (PackedScene) var explosion

onready var game = get_node("/root/Game")

func pick_up(player:Player):
	._ready()
	if explosion==null:
		return
	var _exp = explosion.instance()
	_exp.global_position = global_position
	game.add_child(_exp)
