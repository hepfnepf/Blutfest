extends Weapon

export (int) var projectile_nmbr = 4

func add_to_player() -> void:
	player.get_node("Sprites/torso").visible = false

func remove_from_player() -> void:
	player.get_node("Sprites/torso").visible = true

func shoot_bullet() -> void:
	print_debug("Bum")
	for i in range(projectile_nmbr):
		_shoot_bullet()
	#add_child(bullet)
	increase_spread()

func _shoot_bullet() -> void:
	var bullet = Bullet.instance()
	bullet.global_position = bullet_spawn_position.global_position
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range
	bullet.damage = damage
	game.add_child(bullet)
