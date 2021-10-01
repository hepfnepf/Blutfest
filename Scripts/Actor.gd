extends KinematicBody2D

export (int) var speed = 100
export (int) var max_health = 100

export (float)var time_before_fade=1#after the enemy is dead it takes time_before_fade seconds until the fading begins
export (float)var time_to_fade=5#how long the fading takes

onready var health_Node = $Health
onready var ai = $AI
onready var team_Node = $Team
onready var movement = $Movement
onready var animation_player = $AnimationPlayer
onready var cooldown_timer:Timer = $AttackCooldown
onready var until_fading_timer:Timer = $TimeUntilFading
onready var collision_shape:CollisionShape2D = $CollisionShape2D

onready var player = get_node("/root/Game/Player")

var alive :=true
var fading :=false
var alpha:float = 1

func handle_hit(damage:int, type:int = 1):
	if alive:
		health_Node.health -= damage
		if health_Node.health <= 0:
			start_death_animation()

func start_death_animation():
	alive=false
	ai.alive=false
	movement.stop_movement()
	collision_shape.disabled = true
	z_index = -4
	
	animation_player.stop()
	animation_player.play("Death")

func die():
	until_fading_timer.start(time_before_fade)

func _ready():
	movement.speed = speed
	health_Node.health = max_health
	
	movement.initialize(self, animation_player)
	ai.initialize(movement,team_Node.team,player)
	ai.cooldown_timer = cooldown_timer

func _process(delta):
	if fading:
		alpha -= delta/time_to_fade
		if alpha <=0:
			queue_free()
		modulate = Color(1,1,1,alpha)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		die()


func _on_TimeUntilFading_timeout():
	fading = true
