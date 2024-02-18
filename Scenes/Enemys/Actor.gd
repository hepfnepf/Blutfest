extends KinematicBody2D

signal enemy_dead(points)

export (int) var speed = 100
export (int) var max_health = 100
export (int) var points = 50
export (int) var damage = 20
export (float) var drop_rate = 0.04 #Propability to spawn an item on death

export (float)var time_before_fade=1.0#after the enemy is dead it takes time_before_fade seconds until the fading begins
export (float)var time_to_fade=5.0#how long the fading takes

onready var health_Node = $Health
onready var ai = $AI
onready var team_Node = $Team
onready var movement = $Movement
onready var sprite = $Sprite
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var until_fading_timer:Timer = $TimeUntilFading
onready var collision_shape:CollisionShape2D = $CollisionShape2D
onready var fade_out:Tween = $FadeOut
onready var sound_player:AudioStreamPlayer2D = $AudioStreamPlayer2D

onready var player:Player = get_node_or_null("/root/Game/Player")
onready var game = get_node_or_null("/root/Game")

var alive :=true
var fading :=false
var alpha:float = 1

var sound_prob:float = 0.3

#Effects
var freeze_amount:int=0 #How many frozen effects are stacked on to each other

func _ready():
	movement.speed = speed
	health_Node.health = max_health

	movement.initialize(self, animation_player)
	ai.initialize(movement,team_Node.team)
	ai.damage = damage

	connect("enemy_dead",game,"_on_enemy_killed")

func handle_hit(damage:int, type:int = 1):
	if alive:
		print_debug(player.damage_multi)
		health_Node.health -= damage*player.damage_multi
		if (randf()<sound_prob):
			sound_player.play()
		if health_Node.health <= 0:
			start_death_animation()

func set_damage(new_dmg):
	damage = new_dmg
	ai.damage = damage

func set_max_health(new_health):
	max_health = new_health
	health_Node.health = max_health

func set_speed(new_speed):
	speed=new_speed
	movement.speed = speed

func start_death_animation():
	alive=false
	ai.alive=false
	unfreeze()
	movement.stop_movement()
	movement.alive=false
	collision_shape.queue_free()
	z_index = -4
	emit_signal("enemy_dead",points)
	game.spawner.spawn_rand_item_at_prob(drop_rate,global_position)

	animation_player.stop()
	animation_player.play("Death")



func freeze()->void:
	if !alive:
		return
	if freeze_amount ==0:
		$Ice.show()
		#Ai checks in its process funtion if enemy is frozen. It skips process then.
	freeze_amount+=1

func defreeze()-> void:
	freeze_amount -= 1
	if freeze_amount <= 0:
		unfreeze()
func unfreeze()-> void:
	freeze_amount=0
	$Ice.hide()
	pass


func die()->void:
	until_fading_timer.start(time_before_fade)


func _on_AnimationPlayer_animation_finished(anim_name)->void:
	if anim_name == "Death":
		die()


func _on_TimeUntilFading_timeout()->void:
	fade_out.interpolate_property(self, "modulate:a", 1.0, 0.0,time_to_fade, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	fade_out.start()


# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_FadeOut_tween_completed(object, key)->void:
	queue_free()
