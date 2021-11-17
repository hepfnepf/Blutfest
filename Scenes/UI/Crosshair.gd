extends Node2D

onready var outer_crosshair = $OuterCrosshair

func _process(delta) -> void:
	global_position = get_viewport().get_mouse_position()

func set_spread(new_spread) -> void:
	outer_crosshair.scale = Vector2(new_spread,new_spread)
