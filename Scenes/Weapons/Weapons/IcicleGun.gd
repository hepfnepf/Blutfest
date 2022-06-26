extends Weapon

onready var localAnimationPlayer:AnimationPlayer = $LocalAnimationPlayer
func shoot():
	#animation
	localAnimationPlayer.play("shot")

	#limit fire speed
	shot_timer.start()
	cooldown = true

	#initialize bullet
	shoot_bullet()

	play_sound(SOUNDS.SHOT)

	#handle ammo
	if ammo_infinity_stack == 0:
		ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()
	emit_signal("ammo_changed",ammo)
