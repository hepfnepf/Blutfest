extends Perk

export(int)var ice_damage = 0#gets applied every second an enemy is frozen


func add_effect()->void:
	player.ice_damage += ice_damage

func remove_effect()->void:
	pass

func get_desc()->String:
	return tr(desc)%ice_damage
