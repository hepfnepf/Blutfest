extends KinematicBody2D




var direction:Vector2
var origin:Vector2
var p_range = 0
var speed:float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	move_and_collide(direction*speed)
	if (abs(global_position.distance_to(origin)) >= p_range):
		queue_free()
