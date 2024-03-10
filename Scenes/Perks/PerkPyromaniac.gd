extends Perk


export(float)var explosion_size_inc=0.05
export(float)var explosion_size_cap=2.0

func add_effect()->void:
	player.explosion_amt_size_multi_inc=explosion_size_inc
	player.max_explosion_amt_size_multi=explosion_size_cap

func get_desc()->String:
	return tr(desc)%explosion_size_cap
