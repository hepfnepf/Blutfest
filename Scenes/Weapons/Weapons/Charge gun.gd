extends Weapon


export(float)var charge_rate = 1.0

var is_charging:bool=false setget set_is_charging
var charge_start:int=0
var charge_par_min_size_fac:float=0.0
var charge_par_max_size_fac:float=10.0
onready var charge_particles:CPUParticles2D = $Charger3/Charge

func _ready() -> void:
	._ready()
	$Charger3/Charge/Orb/Sprite/AnimationPlayer.play("Spark")

func check_for_input():
	if Input.is_action_just_pressed("fire"):
		set_is_charging(true)

	if Input.is_action_just_released("fire"):
		set_is_charging(false)
	if Input.is_action_just_released("reload"):# && ammo!= max_ammo:
		reload()

	if is_charging:
		if !cooldown  && !is_reloading:
			if ammo > 0:
				charge()
				#shoot()
			else:
				play_sound(SOUNDS.EMPTY)

func charge()->void:
	if is_charging:
		var scale_fac:float = float((Time.get_ticks_msec()-charge_start))/1000.0*charge_rate
		scale_fac=clamp(scale_fac,charge_par_min_size_fac,charge_par_max_size_fac)
		charge_particles.global_scale = Vector2(scale_fac,scale_fac)

func reload():
	#pass
	.reload()
#	#set_is_charging(false)

func _on_ReloadTimer_timeout():
	._on_ReloadTimer_timeout()
	if Input.is_action_pressed("fire"):#incase you keep holding fire througout the whole reload, it would not shoot using the just_pressed of the input check
		set_is_charging(true)

func set_is_charging(new_is_charging):
	is_charging=new_is_charging
	if is_charging:
		charge_start = Time.get_ticks_msec()
		charge_particles.visible=true
	else:
		if !is_reloading:
			shoot()
		charge_particles.scale=Vector2(0,0)
		charge_particles.visible=false

func shoot():
	if !player.alive:
		return

	#for statistics
	player.shots_fired +=1

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
	bullet.timer.start(float(max_range)/speed)#??, yes max_range already is a float, but without this conversion it did not work
	var scale_fac:float = float((Time.get_ticks_msec()-charge_start))/1000.0*charge_rate
	scale_fac=clamp(scale_fac,charge_par_min_size_fac,charge_par_max_size_fac)
	bullet.damage = damage*player.damage_multi*scale_fac
	bullet.global_scale = $Charger3/Charge/Orb.global_scale#Vector2(scale_fac,scale_fac)
	increase_spread()
