extends Perk

export(float)var medic_multiplier = 2.0

func add_effect()->void:
	player.medic_multiplier = medic_multiplier

func get_desc()->String:
	return tr(desc)%medic_multiplier

