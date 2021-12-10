extends Weapon


func check_for_input():#the pistol shuld only not fire as long as butten is pressed but only on just pressed
	pass

func _unhandled_input(event):#alternetive way to get the input
	if event.is_action_pressed("fire"):
		if ammo > 0 && !is_reloading:
			shoot()
	if event.is_action_released("reload") && ammo != max_ammo:
		reload()

func shoot():	
	#animation
	animation_player.play("shot")
	
	#initiate bullet
	shoot_bullet()
	
	play_sound(SOUNDS.SHOT)
	
	#handle ammo
	ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()	
	emit_signal("ammo_changed",ammo)
