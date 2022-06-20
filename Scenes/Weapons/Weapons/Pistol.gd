extends Weapon


func check_for_input():#the pistol shuld only not fire as long as butten is pressed but only on just pressed
	if Input.is_action_just_pressed("fire"):
		if !cooldown  && !is_reloading:
			if ammo > 0:
				shoot()
			else:
				play_sound(SOUNDS.EMPTY)
	if Input.is_action_just_released("reload"):# && ammo!= max_ammo:
		reload()

func shoot():
	#animation
	animation_player.play("shot")

	#initiate bullet
	shoot_bullet()

	play_sound(SOUNDS.SHOT)

	#handle ammo
	if ammo_infinity_stack == 0:
		ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()
	emit_signal("ammo_changed",ammo)
