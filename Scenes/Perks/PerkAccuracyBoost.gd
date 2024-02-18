extends Perk

export(int)var level = 1

func add_effect()->void:
	player.boost_accuracy_dmg_level= level
