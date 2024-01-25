extends Node2D
class_name Weapon

signal ammo_changed
signal max_ammo_changed
signal reload_percent_change

signal spread_changed(new_spread)


export (int) var max_ammo = 15
export (int) var damage = 20
export (float) var max_range = 300
export (float) var speed = 100#of bullet
export (float) var reload_time = 1.0
export (float) var fire_rate = 10.0 setget set_fire_rate


export (float) var base_spread = 0.3
export (float) var max_spread = 0.5
export (float) var spread_inc = 0.05#per shot
export (float) var spread_dec = 0.04#per second

#export (bool) var does_explode = false
export (float) var explosion_damage = 0.0

export (PackedScene) var Bullet

#Sound effects
export (AudioStream) var shoot_sfx
export (AudioStream) var reload_sfx
export (AudioStream) var empty_sfx

export (float) var shoot_db
export (float) var reload_db
export (float) var empty_db

enum SOUNDS {SHOT,RELOAD,EMPTY}

var ammo:int = 0#ammount of shots in a magazine
var spread:float = 0 #gets set in ready to base_spread, does somehow not work if done here
var is_reloading:bool = false
var cooldown:bool = false
var reload_start_time:int # used for progress bar


var rng = RandomNumberGenerator.new()

#For effects
var ammo_infinity_stack:int = 0 #ammount of ammo ininity applied
var reload_time_delta:float = 0
var fire_rate_delta:int = 0

onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var reload_timer:Timer = $ReloadTimer
onready var bullet_spawn_position = $BulletSpawnPosition
onready var bullet_spawn_direction = $BulletDirection
onready var shot_timer:Timer = $Cooldown
onready var game = get_node("/root/Game")
onready var tween = $Tween
onready var player:Player = get_parent().get_parent()

func _ready():
	rng.randomize()
	spread = base_spread
	ammo = max_ammo
	set_fire_rate(fire_rate)
	emit_signal("spread_changed", spread)

func add_to_player():
	pass

func remove_from_player():
	pass


func _process(delta):
	if !player.alive:
		return
	if is_reloading:
		var percent = reload_timer.time_left/reload_timer.wait_time * 100
		emit_signal("reload_percent_change",percent)
	decrease_spread(delta)
	check_for_input()

func check_for_input():
	if Input.is_action_pressed("fire"):
		if !cooldown  && !is_reloading:
			if ammo > 0:
				shoot()
			else:
				play_sound(SOUNDS.EMPTY)
	if Input.is_action_just_released("reload"):# && ammo!= max_ammo:
		reload()

func shoot():
	#animation
	animation_player.play("shot")

	#limit fire speed
	shot_timer.start()
	cooldown = true

	#initialize bullet
	shoot_bullet()

	play_sound(SOUNDS.SHOT)

	#handle ammo
	if ammo_infinity_stack == 0:
		ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()
	emit_signal("ammo_changed",ammo)

func shoot_bullet():
	var bullet = BulletPool.get_bullet(Bullet,bullet_spawn_position.global_position)
	var dir_vector = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position).normalized()
	var rot = dir_vector.angle()+ rng.randf_range(-spread,spread)
	bullet.player=player
	bullet.rotation = rot
	bullet.direction = Vector2.RIGHT.rotated(rot)
	bullet.speed = speed
	bullet.p_range = max_range
	bullet.damage = damage*player.damage_multi
	bullet.timer.start(float(max_range)/speed)#??, yes max_range already is a float, but without this conversion it did not work
	increase_spread()

"""
Plays one of the gun sounds, determined by the SOUNDS enum. If the sound variable is not assigned, sound does not get played.
"""
func play_sound(sound:int):
	if sound == SOUNDS.SHOT && shoot_sfx != null:
		NonDirectionalSoundPool.play_sound(shoot_sfx, shoot_db)
	elif sound==SOUNDS.RELOAD&& reload_sfx != null:
		NonDirectionalSoundPool.play_sound(reload_sfx, reload_db)
	elif empty_sfx != null:
		NonDirectionalSoundPool.play_sound(empty_sfx, empty_db)


func increase_spread():
	spread *= 1+spread_inc
	if spread > max_spread:
		spread = max_spread
	emit_signal("spread_changed", spread)

func decrease_spread(delta:float):
	if !is_reloading:
		spread -= spread_dec*delta
		if spread < base_spread:
			spread = base_spread
	emit_signal("spread_changed", spread)

func reload():
	if !is_reloading and reload_time != 0:
		is_reloading = true
		play_sound(SOUNDS.RELOAD)
		reload_timer.start(reload_time)
		reload_start_time = OS.get_ticks_msec()
		tween.interpolate_property(self,"spread", spread, base_spread,reload_time )
		tween.start()
	if reload_time == 0:#skip reloading
		_on_ReloadTimer_timeout()

func instant_finish_reloading()->void:
	if is_reloading:
		reload_timer.stop()
		tween.stop_all()
		spread = base_spread
		_on_ReloadTimer_timeout()
		emit_signal("reload_percent_change",0)


func set_fire_rate(new_fire_rate:float):
	fire_rate = new_fire_rate
	if shot_timer != null:
		shot_timer.wait_time = 1/fire_rate

func _on_ReloadTimer_timeout():#after reload is done
	ammo = max_ammo
	emit_signal("ammo_changed",ammo)
	is_reloading = false
	#spread = base_spread

func _on_Cooldown_timeout():
	cooldown = false
