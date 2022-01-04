extends EffectBasis

export (float) var time_scale = 0.2
export (float) var tween_time = 0.5

onready var tween:Tween = $Tween

func add_effect():
	TimeManager.set_time_tweened(time_scale,tween_time)

func remove_effect():
	TimeManager.set_time_tweened(1.0,tween_time)
