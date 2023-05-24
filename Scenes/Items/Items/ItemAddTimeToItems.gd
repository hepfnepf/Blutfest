extends Item

export (float)var time = 10.0

func pick_up(_player:Player):
	get_tree().call_group("Item","increase_lifetime", time)
	.pick_up(_player)
