extends Item


export (float) var health = 50.0

func pick_up(player:Player):
	player.set_health(player.health + health)
	queue_free()
