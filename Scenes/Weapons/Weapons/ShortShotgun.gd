extends Weapon

export (int) var projectile_nmbr = 4

func add_to_player() -> void:
	player.get_node("Sprites/torso").visible = false

func remove_from_player() -> void:
	player.get_node("Sprites/torso").visible = true

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
	bullet.p_range = max_range
	bullet.damage = damage


#The spread function gets overwritten, because the crosshair would get to big else
func increase_spread():
	spread *= 1+spread_inc
	if spread > max_spread:
		spread = max_spread
	emit_signal("spread_changed", spread/10)

func decrease_spread(delta:float):
	if !is_reloading:
		spread -= spread_dec*delta
		if spread < base_spread:
			spread = base_spread
	emit_signal("spread_changed", spread/10)
