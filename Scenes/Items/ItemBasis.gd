extends Area2D
class_name Item

export (PackedScene) var weapon

func pick_up(player):
	player.set_weapon(weapon)
	queue_free()
