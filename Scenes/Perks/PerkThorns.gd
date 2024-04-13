extends Perk

export(int)var damage=30

func add_effect()->void:
	player.thorn_damage = damage
	player.thorn_damage_equal_fac = 0.0


func get_desc()->String:
	return tr(desc)%damage

func _ready()->void:
	add_effect()
