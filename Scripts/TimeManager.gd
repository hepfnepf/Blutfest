extends Node

signal time_scale_changed

var time_scale:float = 1.0 setget set_time_scale

func set_time_scale(value:float) -> void:
	time_scale = value
	Engine.time_scale = value
	AudioServer.global_rate_scale = 2.0 - value
	
	emit_signal("time_scale_changed")
