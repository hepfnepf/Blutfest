extends EffectBasis

export (float) var speed_multiplyer = 1.3

var speed_delta = 0

func add_effect():
	var extra_speed = (speed_multiplyer-1) * player.move_speed
	speed_delta = extra_speed
	player.delta_move_speed += extra_speed
	player.move_speed += extra_speed

func remove_effect():
	player.move_speed -= speed_delta
	player.delta_move_speed -= speed_delta
