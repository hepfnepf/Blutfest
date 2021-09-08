extends KinematicBody2D

export (int) var speed = 100
export (int) var max_health = 100


onready var health_Node = $Health
onready var ai = $AI
onready var team_Node = $Team
onready var movement = $Movement
onready var animation_player = $AnimationPlayer

func handle_hit(damage:int, type:int = 1):
	health_Node.health -= damage
	if health_Node.health <= 0:
		queue_free()

func _ready():
	movement.speed = speed
	health_Node.health = max_health
	
	movement.initialize(self, animation_player)
	ai.initialize(movement,team_Node.team)
	
