extends KinematicBody2D
class_name Player

signal dead
signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal exp_changed(new_exp)
signal exp_limit_changed(new_exp_limit)
signal time_changed(new_time)
signal score_changed(new_score)
signal lock_changed(new_lock_state)
signal leveled_up

export (int) var move_speed = 300
export (int) var max_health = 100 setget set_max_health
export (int) var health = max_health setget set_health
export (PackedScene) var start_weapon = null
export (bool) var invincible:bool = false#for the invincibility item, exported for debugging
export (PackedScene) var explosion = null
export (float) var exp_damage = 100.0
export (float) var exp_size = 5.0

var experience:int = 0 setget set_experience
var experience_limit:int=100
var score:int = 0 setget set_score
var alive:bool = true
var elapsed_time=0 #get increased by 1 sec every time the time counter returns
var locked:bool = false #can the player pick up new guns
var damage_multi:float=1.0

#For effects and perks

#How much of the current value is due to temporary effects
var delta_move_speed:float = 0
var invincible_count:int = 0
var bullet_time_count:int = 0

# For Perks
var heal_up_on_level_up:int = 0
var explosion_on_level_up:bool = false
var spike_balls_explode:bool = false
var spike_ball_explosion_damage:float = 90


onready var weapon = $Weapon
onready var hurt:AudioStreamPlayer = $Hurt
onready var perkManager:PerkManager = $PerkManager
onready var gui = get_node_or_null("/root/Game/GUI")
onready var shockWave=get_node_or_null("/root/Game/ShockWaveLayer/ShockWave")

var velocity:Vector2 = Vector2.ZERO #needed for movement inaccuracy of player
export (float) var friction = 0.01
export (float) var acceleration = 0.1

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if start_weapon != null:
		weapon.set_weapon(start_weapon)

func _physics_process(delta)->void:
	if !alive:
		return

	#Check if the lock-state has to be changed
	if Input.is_action_just_pressed("lock_weapon"):
		locked = !locked
		emit_signal("lock_changed",locked)

	#Movement
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -=1
	if Input.is_action_pressed("move_down"):
		move_vec.y +=1
	if Input.is_action_pressed("move_left"):
		move_vec.x -=1
	if Input.is_action_pressed("move_right"):
		move_vec.x +=1

	move_vec = move_vec.normalized()
	#animateWalk(move_vec)
	#velocity = move_vec.length() * move_speed
	if move_vec.length() > 0:
		velocity = lerp(velocity, move_vec * move_speed,acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO,friction)

	move_and_collide(velocity * delta)

	#self.look_at(get_global_mouse_position()-self.position)
	look_at(get_global_mouse_position())

#Health related, maybe should be outsourced to its own node
func set_health(new_health:int)->void:
	if !alive:
		return
	if new_health > max_health:
		health=max_health
	else:
		health = new_health
	emit_signal("health_changed",health)
	if health <= 0:
		die()

func set_max_health(new_max_health:int)->void:
	if !alive:
		return
	max_health = new_max_health
	emit_signal("max_health_changed",max_health)

func add_points(points:int)->void:
	set_score(score+points)
	set_experience(experience+points)

func set_score(new_score)->void:
	if !alive:
		return
	score=new_score
	emit_signal("score_changed",new_score)

func die()->void:
	emit_signal("dead")
	alive = false

func take_damage(damage:int)->void:
	if !alive or invincible:
		return
	set_health(health - damage)
	hurt.play()

#Experience Management
func set_experience(new_exp:int)->void:
	if !alive:
		return
	experience = new_exp
	emit_signal("exp_changed",experience)
	while experience >= experience_limit:
		level_up()
		#important so that the perk selection does not get called multiple time before a single perk gets selected
		if is_instance_valid(gui):
			yield(gui, "perk_selected")

func level_up():
	if !alive:
		return
	experience -= experience_limit
	print("Level UP")
	emit_signal("leveled_up")

	$LevelUpSound.play()

	if is_instance_valid(shockWave):
		shockWave.start(1.0)
		yield(shockWave,"wave_finished")#removing this line will make the wave appear after perk card selection

	if heal_up_on_level_up:
		set_health(health+heal_up_on_level_up)
	if explosion_on_level_up:
		create_explosion(exp_damage,exp_size)

	perkManager.new_perk_selection()
	emit_signal("exp_changed",experience)
	next_exp_limit()

func next_exp_limit():
	if !alive:
		return
	experience_limit = experience_limit*2
	emit_signal("exp_limit_changed",experience_limit)
	pass

func change_invincibility(change:int):#function to be used from effect to turn the player invincible, it handles stacking of the effect
	invincible_count += change
	if invincible_count <= 0:
		invincible = false
		invincible_count = 0
	else:
		invincible = true

func create_explosion(damage,size):
	var _exp = explosion.instance()
	_exp.global_position=global_position
	_exp.damage = damage
	_exp.scale =Vector2(size,size)
	var game = get_node_or_null("/root/Game")#gets set again, because if game gets reset after player death, this instance will be removed
	if game!=null:
		game.call_deferred("add_child", _exp)

func set_weapon(_weapon):
	if !alive:
		return
	weapon.set_weapon(_weapon)


func _on_Area2D_area_entered(area):
	if !alive:
		return

	if area.is_in_group("Item"):
		if area.has_method("pick_up"):
			if !locked or !area.is_in_group("WeaponItem"):
				area.pick_up(self)
		else:
			print("Item without pickup function")


func _on_ElapsedTime_timeout():
	if !alive:
		return
	elapsed_time += 1
	emit_signal("time_changed",elapsed_time)
