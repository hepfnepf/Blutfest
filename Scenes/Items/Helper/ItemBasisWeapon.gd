extends Item
class_name ItemWeapon

export (PackedScene) var weapon

func pick_up(player):
	player.set_weapon(weapon)
	explode_if_enabled(player)
	queue_free()
