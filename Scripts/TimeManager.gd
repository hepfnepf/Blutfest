extends Node

signal time_scale_changed

var time_scale:float = 1.0 setget set_time_scale

func set_time_scale(value:float) -> void:
	time_scale = value
	Engine.time_scale = value
	AudioServer.global_rate_scale = 2.0 - value

	emit_signal("time_scale_changed")

func set_time_tweened(value:float,fade_time:float) -> void:
	if !is_instance_valid($Tween):
		return
	$Tween.remove_all()
	$Tween.interpolate_property(TimeManager,"time_scale",null,value,fade_time,0,Tween.EASE_OUT)
	$Tween.start()
