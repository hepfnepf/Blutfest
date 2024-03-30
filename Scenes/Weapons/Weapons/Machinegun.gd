extends Weapon

#This gun has a lot of differences
#Normal guns: Every frame it gets chacked if the fire button is currently pressed.
#If the fire rate allows it, a bullet gets shot
#This: On input done the gun gets set to firing and and up to not fire
#sounds similar but has implications regarding sound, and reload

var is_shooting:bool=false
onready var stream:AudioStreamPlayer = $AudioStreamPlayer
var sound_tween = null #fading out the sound


func _ready() -> void:
	._ready()
	sound_tween = get_tree().create_tween()
	sound_tween.connect("finished",self,"_on_fade_out_finished")
	sound_tween.stop()

func add_to_player() -> void:
	player.get_node("Sprites/torso").visible = false

func remove_from_player() -> void:
	player.get_node("Sprites/torso").visible = true
	player.weapon_movement_speed_multi = 1.0


func check_for_input():
	if Input.is_action_just_pressed("fire"):
		set_is_shooting(true)

	if Input.is_action_just_released("fire"):
		set_is_shooting(false)
	if Input.is_action_just_released("reload"):# && ammo!= max_ammo:
		reload()

	if is_shooting:
		if !cooldown  && !is_reloading:
			if ammo > 0:
				shoot()
			else:
				play_sound(SOUNDS.EMPTY)

func reload():
	.reload()
	set_is_shooting(false)

#this gun uses a different soundsystem: Instead of creating a sound every shot,
#it playes a looped audiofile while you shoot, so the normal code has to be overwritten
func play_sound(sound:int):
	if sound == SOUNDS.SHOT && shoot_sfx != null:
		return
	elif sound==SOUNDS.RELOAD&& reload_sfx != null:
		NonDirectionalSoundPool.play_sound(reload_sfx, reload_db)
	elif empty_sfx != null:
		NonDirectionalSoundPool.play_sound(empty_sfx, empty_db)


func _on_ReloadTimer_timeout():
	._on_ReloadTimer_timeout()
	if Input.is_action_pressed("fire"):#incase you keep holding fire througout the whole reload, it would not shoot using the just_pressed of the input check
		set_is_shooting(true)

func set_is_shooting(new_is_shooting):
	is_shooting=new_is_shooting
	if !is_reloading and is_shooting==true:
		stream.play()
		sound_tween.stop()
		stream.volume_db = 1.0
	else:
		if sound_tween:
			sound_tween.kill()
		sound_tween = create_tween()
		sound_tween.tween_property(stream,"volume_db",linear2db(0.01),0.3)
		sound_tween.set_trans(Tween.TRANS_QUINT)
		sound_tween.set_ease(Tween.EASE_OUT)
		sound_tween.play()

	if is_shooting:
		player.weapon_movement_speed_multi = 0.5
	else:
		player.weapon_movement_speed_multi = 1.0

func _on_fade_out_finished()->void:
	stream.stop()
