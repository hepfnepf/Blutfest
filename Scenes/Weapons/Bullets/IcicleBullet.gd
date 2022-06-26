extends Bullet

export (float) var freeze_prob = 0.2
export (PackedScene) var ice_effect

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()

	if body.has_method("handle_hit"):
		var _ice = ice_effect.instance()
		body.handle_hit(damage, Globals.DamageType.PROJECTILE)
		if randf() <= freeze_prob:
			body.add_child(_ice)

