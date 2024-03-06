extends Item

export (int) var points = 100

func pick_up(_player:Player):
	_player.add_points(points)
	explode_if_enabled(_player)
	queue_free()
