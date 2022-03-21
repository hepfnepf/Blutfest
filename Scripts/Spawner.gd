extends Node2D


signal spawned_enemy

export (float)var enemy_spawn_rate= 1.0
export (float)var enemy_spawn_rate_increase=0.02
export (float)var item_spawn_rate=0.05 
export (float)var max_enemys = 200

var enemy_spawn_value:float = 0
var item_spawn_value:float = 0
var game_alive :=true

var map_size_x:float=0#gets set in the Game node
var map_size_y:float=0

#Enemys
export (PackedScene) var default_enemy

#Items
export (Array,PackedScene) var item_array
#Weapon

onready var game = get_node("/root/Game")
onready var debug_gui =get_node("/root/Game/GUI/HUD/VBoxContainer/HBoxContainer3/DebugLayout")
onready var map:Map = get_node("/root/Game/Map")

func _ready():
	connect("spawned_enemy",debug_gui,"_on_enemy_count_changed")
	connect("spawned_enemy",game,"_on_enemy_spawned")

func _process(delta):
	if !game_alive:
		return
	handle_enemy_spawning(delta)
	handle_item_spawning(delta)
	
func handle_item_spawning(delta)->void:
	item_spawn_value += item_spawn_rate*delta
	while (item_spawn_value >= 1):
		item_spawn_value -=1
		spawn_at(item_array[randi()%len(item_array)],random_position_in_map())
		


func handle_enemy_spawning(delta)->void:
	#change spawn probability over time
	enemy_spawn_rate += delta*enemy_spawn_rate_increase
	
	#decides how many enemys are supposed to spawn
	enemy_spawn_value+= enemy_spawn_rate*delta
	if game.enemys_alive >= max_enemys:
		return
	while (enemy_spawn_value >= 1):
		enemy_spawn_value -= 1
		spawn_at(default_enemy,random_position_out_map())
		emit_signal("spawned_enemy")
		if game.enemys_alive >= max_enemys:
			return

func spawn_at(obj,position):
	var _obj = spawn(obj)
	_obj.position = position

func random_position_in_map() -> Vector2:
	var random_x= rand_range(-map_size_x,map_size_x)
	var random_y= rand_range(-map_size_y,map_size_y)
	return Vector2(random_x,random_y)

func random_position_out_map()->Vector2:
	var helper_bit:bool = randi()%2#Decides whether the x-coord shuld be bigger than the border or the y-coord
	var random_x:float=0
	var random_y:float=0
	if helper_bit ==true:
		var helper_int:int = randi()%2*2 -1 #generates eather -1 or 1
		random_x = helper_int*map_size_x+helper_int*20 #time 20 to have some space between the border of the map and th espawn poistion
		random_y = rand_range(-map_size_y,map_size_y)
		
	else:
		var helper_int:int = randi()%2*2 -1 #generates eather -1 or 1
		random_x =  rand_range(-map_size_x,map_size_x)
		random_y= helper_int*map_size_y+helper_int*20
	return Vector2(random_x,random_y)

func spawn(scene):
	var _obj = scene.instance()
	game.add_child(_obj)
	return _obj

func set_map_size(x_size:float,y_size:float)->void:
	map_size_x = x_size/2
	map_size_y = y_size/2
