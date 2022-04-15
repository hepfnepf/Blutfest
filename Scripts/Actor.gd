extends KinematicBody2D

signal enemy_dead(points)

export (int) var speed = 100
export (int) var max_health = 100
export (int) var points = 50
export (float) var drop_rate = 0.04 #Propability to spawn an item on death

export (float)var time_before_fade=1#after the enemy is dead it takes time_before_fade seconds until the fading begins
export (float)var time_to_fade=5#how long the fading takes

onready var health_Node = $Health
onready var ai = $AI
onready var team_Node = $Team
onready var movement = $Movement
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var until_fading_timer:Timer = $TimeUntilFading
onready var collision_shape:CollisionShape2D = $CollisionShape2D
onready var fade_out:Tween = $FadeOut
onready var sound_player:AudioStreamPlayer2D = $AudioStreamPlayer2D

onready var player = get_node("/root/Game/Player")
onready var game = get_node("/root/Game")

var alive :=true
var fading :=false
var alpha:float = 1

var sound_prob:float = 0.3

func handle_hit(damage:int, type:int = 1):
	if alive:
		health_Node.health -= damage
		if (randf()<sound_prob):
			sound_player.play()
		if health_Node.health <= 0:
			start_death_animation()

func start_death_animation():
	alive=false
	ai.alive=false
	movement.stop_movement()
	collision_shape.queue_free()
	z_index = -4
	emit_signal("enemy_dead",points)
	game.spawner.spawn_rand_item_at_prob(drop_rate,global_position)

	animation_player.stop()
	animation_player.play("Death")

func die():
	until_fading_timer.start(time_before_fade)

func _ready():
	movement.speed = speed
	health_Node.health = max_health

	movement.initialize(self, animation_player)
	ai.initialize(movement,team_Node.team)

	connect("enemy_dead",game,"_on_enemy_killed")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Death":
		die()


func _on_TimeUntilFading_timeout():
	fade_out.interpolate_property(self, "modulate:a", 1.0, 0.0,time_to_fade, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_out.start()

func _on_FadeOut_tween_completed(object, key):
	queue_free()
