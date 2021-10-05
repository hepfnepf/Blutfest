extends Node2D

signal ammo_changed
signal max_ammo_changed
signal reload_percent_change
signal shot_fired(ammotype,origin,vector,p_range)


export (int) var weapon_range= 1000 #length of the ray casted when shooting
export (int) var max_ammo = 15
export (int) var damage = 20

var ammo:int = max_ammo
var is_reloading:bool = false 
var reload_start_time:int # used for progress bar

onready var animation_player = $AnimationPlayer
onready var reload_timer:Timer = $ReloadTimer
onready var bullet_spawn_position = $BulletSpawnPosition
onready var bullet_spawn_direction = $BulletDirection
onready var bullet_manager = get_node("/root/Game/BulletManager")

func _ready():	
	connect("shot_fired",bullet_manager,"shot_fired")

func _process(delta):
	if is_reloading:
		var percent = reload_timer.time_left/reload_timer.wait_time * 100
		emit_signal("reload_percent_change",percent)


func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		if ammo > 0 && !is_reloading:
			shoot()

func shoot():
	
	#animation
	animation_player.play("MuzzleFlash")
	
	var direction = bullet_spawn_position.global_position.direction_to(bullet_spawn_direction.global_position)
	emit_signal("shot_fired",Globals.DamageType.PROJECTILE,bullet_spawn_position.global_position,direction,weapon_range)
	
	#handle ammo
	ammo -= 1
	if ammo <= 0:
		ammo = 0
		reload()	
	emit_signal("ammo_changed",ammo)

func reload():
	if !is_reloading:
		is_reloading = true
		reload_timer.start()
		reload_start_time = OS.get_ticks_msec()


func _on_ReloadTimer_timeout():#after reload is done
	ammo = max_ammo
	emit_signal("ammo_changed",ammo)
	is_reloading = false
