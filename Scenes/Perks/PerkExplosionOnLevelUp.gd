extends Perk

func add_effect():
	if player.has_method("level_up"):
		player.explosion_on_level_up = true
		player.create_explosion(player.exp_damage,player.exp_size)
