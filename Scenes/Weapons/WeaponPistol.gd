extends Node2D

export (int) var weapon_range= 1000 #length of the ray casted when shooting

export (int) var mag_size = 15



onready var animation_player = $AnimationPlayer
onready var ray : RayCast2D = $RayCast2D


func _ready():
	ray.cast_to= Vector2(weapon_range, 0)

func _physics_process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("fire"):
		shoot()

func shoot():
	animation_player.play("MuzzleFlash")
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.has_method("handle_hit"):
			obj.handle_hit(10, Globals.DamageType.PROJECTILE)
		
