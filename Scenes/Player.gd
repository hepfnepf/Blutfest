extends KinematicBody2D
class_name Player

signal dead
signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal exp_changed(new_exp)
signal exp_limit_changed(new_exp_limit)
signal time_changed(new_time)
signal score_changed(new_score)

export (int) var move_speed = 300
export (int) var max_health = 100 setget set_max_health
export (int) var health = max_health setget set_health

var experience:int = 0
var experience_limit:int=100
var score:int = 0 setget set_score
var alive:bool = true
var elapsed_time=0 #get increased by 1 sec every time the time counter returns
#onready var Sprite:Sprite = $Sprites
#onready var AnimationPlayer = $AnimationPlayer
onready var Weapon = $Weapon


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if !alive:
		return
	
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
	
	move_and_collide(move_vec * move_speed * delta)
	
	#self.look_at(get_global_mouse_position()-self.position)
	look_at(get_global_mouse_position())



#Health related, maybe should be outsourced to its own node
func set_health(new_health:int):
	if !alive:
		return
	health = new_health
	emit_signal("health_changed",health)
	if health <= 0:
		die()

func set_max_health(new_max_health:int):
	if !alive:
		return
	max_health = new_max_health
	emit_signal("max_health_changed",max_health)

func set_score(new_score):
	if !alive:
			return
	score=new_score
	emit_signal("score_changed",new_score)

func die():
	emit_signal("dead")
	alive = false

func take_damage(damage:int):
	if !alive:
		return
	set_health(health - damage)

#Experience Management
func receive_experience(base_xp:int):
	if !alive:
		return
	experience += base_xp
	while experience >= experience_limit:
		level_up()

func level_up():
	if !alive:
		return
	experience -= experience_limit
	emit_signal("exp_changed",experience)
	next_exp_limit()

func next_exp_limit():
	if !alive:
		return
	experience_limit = experience_limit*2
	emit_signal("exp_limit_changed",experience_limit)
	pass



func set_weapon(weapon):
	if !alive:
		return
	Weapon.set_weapon(weapon)

func _on_Area2D_area_entered(area):
	if !alive:
		return
	if area.is_in_group("Item"):
		if area.has_method("pick_up"):
			area.pick_up(self)
		else:
			print("Item without pickup function")


func _on_ElapsedTime_timeout():
	if !alive:
		return
	elapsed_time += 1
	emit_signal("time_changed",elapsed_time)
