extends Area2D

var direction := Vector2.ZERO
export (float) var speed =100.0
export (int) var damage = 20
var alive := true

onready var smoketrail = $Smoketrail
onready var sprite = $Sprite


func _process(delta):
	if alive:
		position += direction*speed*delta
		smoketrail.add_point(global_position)

func die():
	alive = false
	smoketrail.fade_out(1.0)
	speed = 0.0
	sprite.queue_free()


func _on_Bullet_body_entered(body):
	if !alive:
		return
	die()
	
	if body.has_method("handle_hit"):
		body.handle_hit(damage, Globals.DamageType.PROJECTILE)


func _on_Timer_timeout():
	die()

func _on_trail_faded():
	queue_free()
