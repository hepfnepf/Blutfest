extends Perk

export(int) var health_inc=50

func add_effect()->void:
	player.health+=health_inc

func get_desc():
	return tr(desc)%health_inc
