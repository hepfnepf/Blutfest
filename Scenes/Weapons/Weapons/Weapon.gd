extends Node2D

signal weapon_switch(new_weapon)


onready var current_weapon = null setget set_weapon


func set_weapon(weapon):
	if current_weapon != null:
		current_weapon.remove_from_player()
		current_weapon.queue_free()
	var new_weapon = weapon.instance()
	add_child(new_weapon)
	current_weapon = new_weapon
	current_weapon.add_to_player()
	emit_signal("weapon_switch",current_weapon)
