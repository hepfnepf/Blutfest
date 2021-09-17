extends Node2D

signal ammo_changed
signal max_ammo_changed

export (int) var weapon_range= 1000 #length of the ray casted when shooting
export (int) var max_ammo = 15

var ammo:int = max_ammo
var is_reloading:bool = false 

onready var animation_player = $AnimationPlayer
onready var ray : RayCast2D = $RayCast2D
onready var reload_timer:Timer = $ReloadTimer


func _ready():
	ray.cast_to= Vector2(weapon_range, 0)

func _physics_process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		if ammo > 0 && !is_reloading:
			shoot()

func shoot():
	
	#animation
	animation_player.play("MuzzleFlash")
	
	#handle shot
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.has_method("handle_hit"):
			obj.handle_hit(10, Globals.DamageType.PROJECTILE)
	
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


func _on_ReloadTimer_timeout():#after reload is done
	ammo = max_ammo
	emit_signal("ammo_changed",ammo)
	is_reloading = false
