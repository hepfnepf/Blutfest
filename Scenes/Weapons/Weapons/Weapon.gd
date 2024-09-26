extends Node2D

signal weapon_switch(new_weapon)


onready var current_weapon = null setget set_weapon
onready var cone_crosshair=null

#for statistics
var weapon_time_used={}
var last_time= 0

func _ready() -> void:
	last_time= OS.get_ticks_usec()

func set_weapon(weapon):

	#Statistics
	add_weapon_to_stats(current_weapon)

	if current_weapon != null:
		current_weapon.remove_from_player()
		current_weapon.queue_free()
	var new_weapon = weapon.instance()
	add_child(new_weapon)
	current_weapon = new_weapon
	cone_crosshair.global_position=current_weapon.bullet_spawn_direction.global_position
	current_weapon.add_to_player()

	emit_signal("weapon_switch",current_weapon)

func add_weapon_to_stats(weapon=current_weapon):
	if weapon:
		if weapon_time_used.has(weapon.get_script().get_path()):
			weapon_time_used[weapon.get_script().get_path()]+=OS.get_ticks_usec()-last_time
		else:
			weapon_time_used[weapon.get_script().get_path()] = OS.get_ticks_usec()-last_time
		last_time = OS.get_ticks_usec()
