extends Weapon


var shots_fired:int = 0 setget set_shots_fired
var damage_boost:int = 0

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
	player.shots_fired+=1
	set_shots_fired(shots_fired+1)
	#animation
	animation_player.play("shot")
	play_sound(SOUNDS.SHOT)
	#initiate bullet
	shoot_bullet()

	#handle ammo
	if ammo_infinity_stack == 0:
		ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()
	emit_signal("ammo_changed",ammo)

func shoot_bullet():
	var bullet = BulletPool.get_bullet(Bullet,bullet_spawn_position.global_position)
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.player=player
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range*player.range_multi
	bullet.damage = (damage+damage_boost)*player.damage_multi
	bullet.timer.start(float(max_range*player.range_multi)/speed)#??, yes max_range already is a float, but without this conversion it did not work
	increase_spread()

func set_shots_fired(new_shots_fired)->void:
	shots_fired=new_shots_fired
	damage_boost = shots_fired/5
