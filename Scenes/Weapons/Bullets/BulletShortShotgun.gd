extends Bullet

"""
Copy of CleanBullet2 but damage depends on distance.
"""


export (float) var penalty_free_distance = 500.0 #Below this distance, the damage is 100%
export (float) var fallof_per_dis = 0.1 # Decrease per meter

var start_pos:Vector2 = Vector2.ZERO


func _ready():
	._ready()
	start_pos = global_position

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()

	var distance_vec:Vector2 = global_position - start_pos
	var distance = distance_vec.length()

	var _damage = damage

	if distance >= penalty_free_distance:
		_damage = damage - fallof_per_dis* (distance - penalty_free_distance)

	_damage = clamp(_damage,3,damage)

	if body.has_method("handle_hit"):
		body.handle_hit(_damage, Globals.DamageType.PROJECTILE)
		if (is_instance_valid(player)):
			player.enemies_hit +=1

# ---------------- For Object Pooling --------------
#Get called from pool
func reset():
	.reset()
	start_pos = global_position
