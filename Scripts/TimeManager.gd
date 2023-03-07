extends Node

signal time_scale_changed

#var time_scale:float = 1.0 setget set_time_scale
#stack used for temporary effects that need to store and restore time before
var stored_scale:Array=[]

func set_time_scale(value:float,store:bool=false) -> void:
	if store:
		stored_scale.append(Engine.time_scale)
	
	#time_scale = value
	Engine.time_scale = value
	AudioServer.global_rate_scale = 2.0 - value

	emit_signal("time_scale_changed")

func restore_from_stored_time()->void:
	assert(stored_scale.size()>=1,"Tried to retrieve time, without it being saved first.")
	set_time_scale(stored_scale.pop_back())

func set_time_tweened(value:float,fade_time:float) -> void:
	if !is_instance_valid($Tween):
		return
	$Tween.remove_all()
	$Tween.interpolate_property(TimeManager,"time_scale",null,value,fade_time,0,Tween.EASE_OUT)
	$Tween.start()
