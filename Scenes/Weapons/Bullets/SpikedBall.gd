extends Bullet

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()

	if body.has_method("handle_hit"):
		body.handle_hit(damage, Globals.DamageType.PROJECTILE)
		if (is_instance_valid(player)):
			player.enemies_hit +=1
	if exp_dmg != 0.0:
		explode()
	elif is_instance_valid(player) and player.spike_balls_explode:
		exp_dmg = player.spike_ball_explosion_damage
		explode()

func die():
	if is_instance_valid(player) and player.spike_balls_explode_on_death:
		exp_dmg = player.spike_ball_explosion_damage
		explode()
	.die()

