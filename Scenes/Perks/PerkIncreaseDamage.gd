extends Perk

export(float)var dmg_mult_inc=0.2

func add_effect()->void:
	player.damage_multi += dmg_mult_inc

func get_desc():
	return tr(desc)%(dmg_mult_inc*100)