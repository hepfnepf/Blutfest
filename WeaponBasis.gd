extends Node2D
class_name Weapon_basis

signal ammo_changed
signal max_ammo_changed
signal reload_percent_change
signal shot_fired(ammotype,origin,vector,p_range)


export (int) var max_ammo = 15
export (int) var damage = 20
export (int) var max_range = 300
export (int) var speed = 100
export (int) var reload_time = 1
export (int) var fire_rate = 10

export (PackedScene) var Bullet


var ammo:int = max_ammo
var is_reloading:bool = false 
var cooldown:bool = false
var reload_start_time:int # used for progress bar

onready var animation_player = $AnimationPlayer
onready var reload_timer:Timer = $ReloadTimer
onready var bullet_spawn_position = $BulletSpawnPosition
onready var bullet_spawn_direction = $BulletDirection
onready var shot_timer:Timer = $Cooldown
onready var game = get_node("/root/Game")

func _process(delta):
	if is_reloading:
		var percent = reload_timer.time_left/reload_timer.wait_time * 100
		emit_signal("reload_percent_change",percent)
	check_for_input()

func check_for_input():
	if Input.is_action_pressed("fire"):
		if !cooldown && ammo > 0 && !is_reloading:
			shoot()

func shoot():	
	#animation
	animation_player.play("shot")
	
	#limit fire speed
	shot_timer.start(1/fire_rate)
	cooldown = true
	
	#initiate bullet
	init_bullet()
	
	#handle ammo
	ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()	
	emit_signal("ammo_changed",ammo)

func init_bullet():
	pass


func reload():
	if !is_reloading:
		is_reloading = true
		reload_timer.start(reload_time)
		reload_start_time = OS.get_ticks_msec()

func _on_ReloadTimer_timeout():#after reload is done
	ammo = max_ammo
	emit_signal("ammo_changed",ammo)
	is_reloading = false

func _on_Cooldown_timeout():
	cooldown = false
