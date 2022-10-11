extends EffectBasis

export (float) var time_scale = 0.2
export (float) var tween_time = 0.5

onready var tween:Tween = $Tween

func add_effect():
	player.bullet_time_count +=1
	if player.bullet_time_count == 1:
		TimeManager.set_time_tweened(time_scale,tween_time)



func remove_effect():
	player.bullet_time_count -=1
	if player.bullet_time_count == 0:
		TimeManager.set_time_tweened(1.0,tween_time)#


