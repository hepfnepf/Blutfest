extends Perk


export(float)var regeneration_amnt = 1.0

func add_effect()->void:
	player.regeneration_perk=true
	player.regenerationTimer.start(player.seconds_to_start_regeneration)

func get_desc()->String:
	return tr(desc)%[player.seconds_to_start_regeneration,regeneration_amnt]
