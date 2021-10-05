extends Weapon


func shoot():	
	#animation
	animation_player.play("shot")
	
	#limit fire speed
	#shot_timer.start(1/fire_rate)
	#cooldown = true
	
	#initiate bullet
	shoot_bullet()
	
	#handle ammo
	ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()	
	emit_signal("ammo_changed",ammo)
