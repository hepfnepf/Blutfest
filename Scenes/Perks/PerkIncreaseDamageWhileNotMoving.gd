extends Perk

export(float)var increased_dmg = 0.5

func add_effect() -> void:
	player.dmg_multi_not_moving += increased_dmg
	
func get_desc():
	return tr(desc)%(increased_dmg*100)
