extends Perk

export(float)var dmg_mult_inc=0.2

func add_effect()->void:
	player.dmg_base_multi += dmg_mult_inc
	player.calculate_damage_multiplier()

func get_desc():
	return tr(desc)%(dmg_mult_inc*100)
