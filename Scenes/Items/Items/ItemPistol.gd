extends Area2D

export (PackedScene) var weapon_pistol

func pick_up(player):
	player.set_weapon(weapon_pistol)
	#player.Sprite.$Weapon.set_weapon(weapon_pistol)
	queue_free()
