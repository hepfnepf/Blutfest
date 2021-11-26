extends Area2D
class_name Bullet
"""
This is meant to inherit from. Not to be used directly.
TODO:
	Add a Smoketrail to your scene.
"""

var direction := Vector2.ZERO
var speed =100.0
var p_range=500
var damage = 20
var alive := true

onready var smoketrail = $Smoketrail
onready var sprite = $Sprite
onready var timer = $Timer

func _ready():
	pass

func _process(delta):
	if alive:
		move(delta)

func move(delta):
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
