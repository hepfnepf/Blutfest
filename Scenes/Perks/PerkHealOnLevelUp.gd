extends Perk

export (float)var health_inc=25.0

func get_desc()->String:
	return tr(desc)%health_inc

func add_effect():
	if player.has_method("level_up"):
		player.heal_up_on_level_up += 25
