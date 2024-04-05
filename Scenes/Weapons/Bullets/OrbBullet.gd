extends Bullet

func _ready() -> void:
	._ready()
	sprite = $Orb

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	#die()

	if body.has_method("handle_hit"):
		damage = damage - body.handle_hit(damage, Globals.DamageType.PROJECTILE)
		if (is_instance_valid(player) and direct):
			player.enemies_hit +=1
	if exp_dmg != 0.0 and !body.is_in_group("Border"):
		explode()
	if damage <1:
		die()

func die():
	if alive:
		alive = false
		speed = 0.0
		sprite.visible = false
