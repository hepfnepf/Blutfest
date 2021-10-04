extends Node2D

var Smoketrail = preload("res://Scenes/Weapons/Smoketrail.tscn")
var Bullet  = preload("res://Scenes/Weapons/Bullet2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("fire"):
		var bullet = Bullet.instance()
		bullet.position = get_global_mouse_position()
		add_child(bullet)
