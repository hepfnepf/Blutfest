extends Weapon


export var explosion_size:float = 1.0
export var explode_on_death:bool=false


func shoot_bullet():
	player.shots_fired+=1

	var bullet:Bullet = BulletPool.get_bullet(Bullet,bullet_spawn_position.global_position)
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.player=player
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range*player.range_multi
	bullet.damage = damage#damage
	#bullet.explodes=true
	bullet.explode_on_death=explode_on_death
	bullet.exp_dmg = explosion_damage
	bullet.exp_size = explosion_size
	bullet.timer.start(float(max_range*player.range_multi)/speed)#??, yes max_range already is a float, but without this conversion it did not work
	increase_spread()
