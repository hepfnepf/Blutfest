extends Perk

export(float)var range_mult_inc = 0.25

func add_effect()->void:
	player.range_multi += range_mult_inc

func get_desc():
	return tr(desc)%(range_mult_inc*100)
