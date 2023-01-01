extends Bullet

export (PackedScene) var explosion
var exp_size:float = 1.0

onready var game = get_node("/root/Game")
onready var orig = $ExplosionOrigin

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()
	
	if game != null:
		var _exp = explosion.instance()
		_exp.global_position=orig.global_position
		_exp.damage = damage
		_exp.scale =Vector2(exp_size,exp_size)
		game.call_deferred("add_child", _exp)
