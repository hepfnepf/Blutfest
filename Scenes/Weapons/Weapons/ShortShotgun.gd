extends Weapon

export (int) var projectile_nmbr = 4

func add_to_player() -> void:
	player.get_node("Sprites/torso").visible = false
	.add_to_player()

func remove_from_player() -> void:
	player.get_node("Sprites/torso").visible = true
	.remove_from_player()

func shoot_bullet() -> void:
	for _i in range(projectile_nmbr):
		_shoot_bullet()
	increase_spread()

func _shoot_bullet() -> void:
	var bullet = BulletPool.get_bullet(Bullet,bullet_spawn_position.global_position)
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.player=player
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range*player.range_multi
	bullet.damage = damage*player.damage_multi
	bullet.timer.start(float(max_range*player.range_multi)/speed)#??, yes max_range already is a float, but without this conversion it did not work
