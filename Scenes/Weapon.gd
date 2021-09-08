extends Node2D

signal weapon_switch(new_weapon)


export (PackedScene) var weapon_none

var current_weapon = null setget set_weapon

var weapon_dict = {"NONE":weapon_none}

func _ready():
	set_weapon(weapon_none)

func set_weapon(weapon):
	if current_weapon != null:
		current_weapon.queue_free()
	var new_weapon = weapon.instance()
	add_child(new_weapon)
	current_weapon = new_weapon
