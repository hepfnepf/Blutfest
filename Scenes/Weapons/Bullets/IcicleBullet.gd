extends Bullet

export (float) var freeze_prob = 0.2
export (PackedScene) var ice_effect

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()

	if body.has_method("handle_hit"):
		body.handle_hit(damage, Globals.DamageType.PROJECTILE)
		if (is_instance_valid(player)):
			player.enemies_hit +=1
		if randf() <= freeze_prob:
			var _ice = ice_effect.instance()
			_ice.player=player
			body.add_child(_ice)

