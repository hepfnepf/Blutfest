extends Node2D

onready var outer_crosshair = $OuterCrosshair

export (float)var max_size = 1
export (float)var min_size = 0.5
export (float)var spread_scaler = 50

func _process(delta) -> void:
	global_position = get_viewport().get_mouse_position()

func set_spread(new_spread) -> void:
	var _spread = clamp(new_spread*spread_scaler,min_size,max_size)
	outer_crosshair.scale = Vector2(_spread,_spread)
