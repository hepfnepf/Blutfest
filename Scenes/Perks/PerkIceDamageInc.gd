extends Perk

export(float)var ice_damage_mult_inc = 0.2#


func add_effect()->void:
	player.ice_damage_mult += ice_damage_mult_inc

func remove_effect()->void:
	pass

func get_desc()->String:
	return tr(desc)%(player.ice_damage_mult + ice_damage_mult_inc)
