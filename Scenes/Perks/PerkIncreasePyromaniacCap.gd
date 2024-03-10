extends Perk

export(float)var max_explosion_amt_size_multi=0.0

func add_effect():
	player.max_explosion_amt_size_multi = max_explosion_amt_size_multi

func get_desc()->String:
	return tr(desc)%max_explosion_amt_size_multi
