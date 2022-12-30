extends Item


export (float) var bullet_rate = 10.0
export (float) var rot_speed = 10.0
export (float) var duration = 5.0

#Bullet parameter
export (PackedScene) var bullet
export (int) var damage = 20
export (int) var max_range = 300
export (int) var speed = 100#of bullet

export (AudioStream) var shoot_sfx
export (float) var shoot_db

var is_active:bool = false
var time:float = 0 #Helper for spawning speed
onready var game = get_node("/root/Game")

func pick_up(_player:Player):
	is_active = true
	timer.paused = true
	$Duration.start(duration)


func _process(delta):
	if is_active:
		time+=delta

		rotation_degrees += rot_speed * delta

		while(time >= 1/bullet_rate):
			shoot_bullet()
			time -= 1/bullet_rate

func shoot_bullet():
	var _bullet = BulletPool.get_bullet(bullet,$Sprite/SpawnPosition.global_position)
	var dir_vector = $Sprite/SpawnPosition.global_position.direction_to($Sprite/ShootDirection.global_position).normalized()
	var rot = dir_vector.angle()
	_bullet.rotation = rot
	_bullet.speed = speed
	_bullet.direction = Vector2.RIGHT.rotated(rot)
	_bullet.p_range = max_range
	_bullet.damage = damage
	NonDirectionalSoundPool.play_sound(shoot_sfx, shoot_db)


func _on_Duration_timeout():
	tween_out.interpolate_property(self,"scale",null,Vector2(0,0),0.3)
	tween_out.start()
