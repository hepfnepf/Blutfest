extends KinematicBody2D
class_name Player

signal dead
signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal exp_changed(new_exp)
signal exp_limit_changed(new_exp_limit)

export (int) var move_speed = 300
export (int) var max_health = 100 setget set_max_health
export (int) var health = max_health setget set_health

var experience:int = 0
var experience_limit=100

onready var Sprite = $Sprites
onready var AnimationPlayer = $AnimationPlayer
onready var Weapon = $Weapon

func animateWalk(move_vec):
	#does not work
	if move_vec != Vector2.ZERO:
		if (move_vec.x < 0):
			if(move_vec.y < 0):
				AnimationPlayer.play("walk_forward_left")
			elif(move_vec.y > 0):
				AnimationPlayer.play("walk_backwards_left")
			else:
				AnimationPlayer.play("walk_left")
		elif(move_vec.x > 0):
			if(move_vec.y < 0): 
				AnimationPlayer.play("walk_forward_right")
			elif(move_vec.y > 0):
				AnimationPlayer.play("walk_backwards_right")
			else:
				AnimationPlayer.play("walk_right")
		else:
			if (move_vec.y < 0):
				AnimationPlayer.play("walk_forward")
			elif (move_vec.y > 0):
				AnimationPlayer.play("walk_backwards")
			else:
				AnimationPlayer.play("none")
			
		AnimationPlayer.playback_speed = 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
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
	health = new_health
	emit_signal("health_changed")
	if health <= 0:
		die()

func set_max_health(new_max_health:int):
	max_health = new_max_health
	emit_signal("max_health_changed")

func die():
	print("dead")
	emit_signal("dead")

func take_damage(damage:int):
	set_health(health - damage)

#Experience Management
func receive_experience(base_xp:int):
	experience += base_xp
	while experience >= experience_limit:
		level_up()

func level_up():
	experience -= experience_limit
	emit_signal("exp_changed")
	next_exp_limit()

func next_exp_limit():
	experience_limit = experience_limit*2
	emit_signal("exp_limit_changed")
	pass



func set_weapon(weapon):
	Weapon.set_weapon(weapon)

func _on_Area2D_area_entered(area):
	print(area.name)
	if area.is_in_group("Item"):
		if area.has_method("pick_up"):
			area.pick_up(self)
		else:
			print("Item without pickup function")
