extends Node2D
class_name Weapon

signal ammo_changed
signal max_ammo_changed
signal reload_percent_change
#signal shot_fired(ammotype,origin,vector,p_range) #currently not used
signal spread_changed(new_spread)


export (int) var max_ammo = 15
export (int) var damage = 20
export (int) var max_range = 300
export (int) var speed = 100
export (int) var reload_time = 1
export (int) var fire_rate = 10


export (float) var base_spread = 0.3
export (float) var max_spread = 0.5
export (float) var spread_inc = 0.05#per shot
export (float) var spread_dec = 0.04#per second


export (PackedScene) var Bullet


var ammo:int = max_ammo
var spread:float = 0 #gets set in ready to base_spread, does somehow not work if done here
var is_reloading:bool = false 
var cooldown:bool = false
var reload_start_time:int # used for progress bar
var rng = RandomNumberGenerator.new()

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var reload_timer:Timer = $ReloadTimer
onready var bullet_spawn_position = $BulletSpawnPosition
onready var bullet_spawn_direction = $BulletDirection
onready var shot_timer:Timer = $Cooldown
onready var game = get_node("/root/Game")

func _ready():
	rng.randomize()
	spread = base_spread
	emit_signal("spread_changed", spread/base_spread)

func _process(delta):
	if is_reloading:
		var percent = reload_timer.time_left/reload_timer.wait_time * 100
		emit_signal("reload_percent_change",percent)
	decrease_spread(delta)
	check_for_input()

func check_for_input():
	if Input.is_action_pressed("fire"):
		if !cooldown && ammo > 0 && !is_reloading:
			shoot()
	if Input.is_action_just_released("reload"):# && ammo!= max_ammo:
		reload()

func shoot():	
	#animation
	animation_player.play("shot")
	
	#limit fire speed
	shot_timer.start(1/fire_rate)
	cooldown = true
	
	#initiate bullet
	shoot_bullet()
	
	#handle ammo
	ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()	
	emit_signal("ammo_changed",ammo)

func shoot_bullet():
	var bullet = Bullet.instance()
	bullet.global_position = bullet_spawn_position.global_position
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range
	bullet.damage = damage
	game.add_child(bullet)
	increase_spread()

func increase_spread():
	spread *= 1+spread_inc
	if spread > max_spread:
		spread = max_spread
	emit_signal("spread_changed", spread/base_spread)

func decrease_spread(delta:float):
	spread -= spread_dec*delta
	if spread < base_spread:
		spread = base_spread
	emit_signal("spread_changed", spread/base_spread)
func reload():
	if !is_reloading:
		is_reloading = true
		reload_timer.start(reload_time)
		reload_start_time = OS.get_ticks_msec()
		spread = base_spread

func _on_ReloadTimer_timeout():#after reload is done
	ammo = max_ammo
	emit_signal("ammo_changed",ammo)
	is_reloading = false

func _on_Cooldown_timeout():
	cooldown = false
