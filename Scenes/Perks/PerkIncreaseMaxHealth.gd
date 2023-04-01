extends Perk

export (float) var max_health_increase

func add_effect()->void:
	player.max_health+=max_health_increase
