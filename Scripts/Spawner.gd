extends Node2D

export (int) var map_size_x
export (int) var map_size_y

export (float)var spawn_rate= 1.0
export (float) var spawn_rate_increase=0.2
var spawn_value:float = 0

export (PackedScene) var default_enemy

onready var game = get_node("/root/Game")

func _process(delta):
	#change spawn probability over time
	spawn_rate += delta*spawn_rate_increase
	
	#decides how many enemys are supposed to spawn
	spawn_value+= spawn_rate*delta
	while (spawn_value >= 1):
		spawn_value -= 1
		spawn_at(random_position())

func spawn_at(position):
	var enemy = spawn()
	enemy.position = position

func random_position() -> Vector2:
	var random_x= rand_range(-map_size_x/2,map_size_x/2)
	var random_y= rand_range(-map_size_y/2,map_size_y/2)
	return Vector2(random_x,random_y)


func spawn():
	var enemy = default_enemy.instance()
	game.add_child(enemy)
	return enemy
