extends Area2D
class_name Bullet
"""
This is meant to inherit from. Not to be used directly.
"""

var direction := Vector2.ZERO
var template:PackedScene = null #gets set when instanced, needed for bullet pool is the packed scene the bullet is an instance of
var player:Player = null

#For exploding bullets
#A bullet explodes, if exp_dmg != 0
var explosion:PackedScene=preload("res://Scenes/Items/EffectNodes/Explosion.tscn")
var exp_size:float = 1.0
var exp_dmg:float=0.0 #0 means there is now explosion
var explode_on_death:bool=false # makes it so, that when not hitting anything, an explosion will still occur when this bullets lifetime ends

#Get set by the weapon
var speed =100.0
var p_range=500
var damage = 20
var alive := true

onready var smoketrail:Smoketrail = $Smoketrail#does not exist in basis. Only in the inherited bullets
onready var sprite:Sprite = $Sprite
onready var timer:Timer = $Timer
onready var game = get_node_or_null("/root/Game")
onready var orig:Position2D = $ExplosionOrigin

func _ready():
	#timer.start(p_range/speed)
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
		if (is_instance_valid(player)):
			player.enemies_hit +=1
	if exp_dmg != 0.0 and !body.is_in_group("Border"):
		explode()

func explode() -> void:
	game = get_node_or_null("/root/Game")#gets set again, because if game gets reset after player death, this instance will be removed
	if game==null or player==null:
		return
	var _exp = explosion.instance()
	_exp.global_position=orig.global_position
	_exp.damage=exp_dmg
	_exp.scale =Vector2(exp_size,exp_size)*player.explosion_amt_size_multi
	player.explosion_amnt +=1
	game.call_deferred("add_child", _exp)

func _on_Timer_timeout():
	if explode_on_death:
		explode()
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
