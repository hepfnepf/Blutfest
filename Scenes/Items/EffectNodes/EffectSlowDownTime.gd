extends EffectBasis

export (float) var time_scale = 0.2

func add_effect():
	TimeManager.set_time_scale(time_scale)

func remove_effect():
	TimeManager.set_time_scale(1.0)
