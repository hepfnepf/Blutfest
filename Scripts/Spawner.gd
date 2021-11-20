extends Node2D


signal spawned_enemy

export (float)var spawn_rate= 1.0
export (float) var spawn_rate_increase=0.02

var spawn_value:float = 0
var game_alive :=true

var map_size_x:float=0#gets set in the Game node
var map_size_y:float=0

export (PackedScene) var default_enemy

onready var game = get_node("/root/Game")
onready var debug_gui =get_node("/root/Game/GUI/MarginContainer/VBoxContainer/HBoxContainer3/DebugLayout")
onready var map:Map = get_node("/root/Game/Map")

func _ready():
	connect("spawned_enemy",debug_gui,"_on_enemy_count_changed")
func _process(delta):
	if !game_alive:
		return
	#change spawn probability over time
	spawn_rate += delta*spawn_rate_increase
	
	#decides how many enemys are supposed to spawn
	spawn_value+= spawn_rate*delta
	while (spawn_value >= 1):
		spawn_value -= 1
		spawn_at(random_position())
		emit_signal("spawned_enemy")

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

func set_map_size(x_size:float,y_size:float)->void:
	map_size_x = x_size
	map_size_y = y_size
