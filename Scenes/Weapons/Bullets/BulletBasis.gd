extends Area2D
class_name Bullet
"""
This is meant to inherit from. Not to be used directly.
"""

var direction := Vector2.ZERO
var template:PackedScene = null #gets set when instanced, needed for bullet pool is the packed scene the bullet is an instance of

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

func _physics_process(delta):
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
		sprite.visible = false

func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	die()

	if body.has_method("handle_hit"):
		body.handle_hit(damage, Globals.DamageType.PROJECTILE)

func _on_Timer_timeout():
	die()

func _on_trail_faded():
	BulletPool.store_bullet(self) # calls disable() on bullet

# ---------------- For Object Pooling --------------
#Get called from pool
func reset():
	alive = true
	visible = true
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	$CollisionShape2D.disabled = false

	#revert the stuff from die()
	sprite.visible = true
	smoketrail.reset()
	timer.start()


func disable():
	# Not just removing the child, because adding it tot the tree seems to be a problem
	alive=false
	visible=false
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	$CollisionShape2D.disabled = true
	smoketrail.disable()
