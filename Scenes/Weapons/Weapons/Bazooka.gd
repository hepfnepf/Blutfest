extends Weapon


export var explosion_size:float = 1.0


func shoot_bullet():
	var bullet = BulletPool.get_bullet(Bullet,bullet_spawn_position.global_position)
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.player=player
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range
	bullet.damage = damage#damage
	#bullet.explodes=true
	bullet.exp_dmg = explosion_damage
	bullet.exp_size = explosion_size
	increase_spread()
