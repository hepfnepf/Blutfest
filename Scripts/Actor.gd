extends KinematicBody2D

export (int) var speed = 100
export (int) var max_health = 100


onready var health_Node = $Health
onready var ai = $AI
onready var team_Node = $Team
onready var movement = $Movement
onready var animation_player = $AnimationPlayer
onready var cooldown_timer:Timer = $AttackCooldown
onready var player = get_node("/root/Game/Player")

var alive :=true

func handle_hit(damage:int, type:int = 1):
	if alive:
		health_Node.health -= damage
		if health_Node.health <= 0:
			start_death_animation()

func start_death_animation():
	alive=false
	ai.alive=false
	movement.stop_movement()
	
	animation_player.stop()
	animation_player.play("Death")
	print("here")

func die():
	queue_free()

func _ready():
	movement.speed = speed
	health_Node.health = max_health
	
	movement.initialize(self, animation_player)
	ai.initialize(movement,team_Node.team,player)
	ai.cooldown_timer = cooldown_timer
	


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		die()
