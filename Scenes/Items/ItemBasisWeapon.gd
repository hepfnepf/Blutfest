extends Item
class_name ItemWeapon

export (PackedScene) var weapon

func pick_up(player):
	player.set_weapon(weapon)
	queue_free()
