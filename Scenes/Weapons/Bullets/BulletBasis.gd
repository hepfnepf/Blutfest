extends Area2D
class_name Bullet
"""
This is meant to inherit from. Not to be used directly.
"""

var direction := Vector2.ZERO

#Get set by the weapon
var speed =100.0
var p_range=500
var damage = 20
var alive := true

onready var smoketrail = $Smoketrail#does not exist in basis. Only in the inherited bullets
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
	if alive:
		alive = false
		smoketrail.fade_out(1.0)
		speed = 0.0
		sprite.queue_free()#This makes sure the traile fades slowly. When done it sends the _on_trail_faded-Signal.

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()

	if body.has_method("handle_hit"):
		body.handle_hit(damage, Globals.DamageType.PROJECTILE)

func _on_Timer_timeout():
	die()

func _on_trail_faded():
	queue_free()
