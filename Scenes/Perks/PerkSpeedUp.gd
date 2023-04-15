extends Perk

export(float)var speed_inc_perc=20

func add_effect()->void:
	player.move_speed *=1+speed_inc_perc/100

func get_desc():
	return tr(desc)%(speed_inc_perc)
