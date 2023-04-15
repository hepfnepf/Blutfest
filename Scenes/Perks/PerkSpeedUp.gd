extends Perk

export(float)var speed_multi=1.2

func add_effect()->void:
	player.move_speed *=speed_multi

func get_desc():
	return tr(desc)%((speed_multi-1.0)*100.0)
