extends Perk

export(float)var damage_multi = 1.0

func add_effect()->void:
	player.thorn_damage_equal_fac = damage_multi
	player.thorn_damage=0
