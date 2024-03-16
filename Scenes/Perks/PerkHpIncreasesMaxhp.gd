extends Perk

export(int)var perk_level=1
func add_effect()->void:
	player.hp_increase_increases_maxhp_lvl = perk_level
