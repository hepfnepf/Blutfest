extends Item


export (float) var health = 50.0

func pick_up(player:Player):
	player.health+=health*player.medic_multiplier
	.pick_up(player)
