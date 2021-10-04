extends Node

#export (float) var bullet_speed = 100
export (PackedScene) var default_bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shot_fired(ammotype,origin,dir_vector,p_range):
	var bul = default_bullet.instance()
	bul.position = origin
	#var rotation_vec = bul.position.direction_to(dir_vector)
	bul.rotate(dir_vector.angle())
	#bul.origin = origin
	#bul.set_range(p_range)
	bul.direction = dir_vector.normalized()
	#bul.speed = bullet_speed
	add_child(bul)
