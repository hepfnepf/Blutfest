extends Perk

export(float)var vampire_percent=0.0

func add_effect()->void:
	player.vampire_percent = vampire_percent

func get_desc()->String:
	return tr(desc)%vampire_percent
