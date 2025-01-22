extends Node2D
class_name Spawner
##
## This Script handles all spawning of items and enemys.
##
## @desc:
##     This script manages automatic and manual spawning.
##     Automatic: The contiunues spawning of items/enemys over time on the map. This script includes parameters,
##     to allow you to manipulate the rate and type of spawned objets
##     Active: Called from other scripts to spawn thigs. E.g. items on the according positions after an enemy died.
##
## @tutorial:***
##
##

signal spawned_enemy
signal difficulty_changed

#Modify automatic spawning
export (float)var enemy_spawn_rate= 1.0
export (float)var enemy_spawn_rate_increase=0.02
export (float)var item_spawn_rate=0.05
export (int)var max_enemys = 200

#Modify difficulty
#Currently effects the multiplayer on all enemys base values
#All enemys get the same boost
export (float)var enemy_speed_increase=0.02
export (float)var enemy_health_increase=0.02
export (float)var enemy_damage_increase=0.02
export (float)var enemy_view_range_increase=0.01#not implemented yet

var enemy_speed_mult:float = 1.0
var enemy_health_mult:float= 1.0
var enemy_damage_mult:float= 1.0
var enemy_view_range_mult:float = 1.0#not implemented yet


var enemy_spawn_value:float = 0
var item_spawn_value:float = 0
var game_alive :=true

var map_size_x:float=0#gets set in the Game node
var map_size_y:float=0

#Enemys
export (PackedScene) var default_enemy

#Items
export (Array,PackedScene) var item_array
export (Array, int)var item_likelihood setget changed_likelihood##likelihood for an item to be spawned relative to eachtother.(10 = 2x as likely as 5)
var item_probs:Array = [] #Gets calculated from item_likelihood. Actual probability.

#Other
export (PackedScene) var explosion

onready var game = get_node_or_null("/root/Game")
onready var debug_gui =get_node_or_null("/root/Game/GUI/HUD/VBoxContainer/DebugLayout")
onready var map:Map = get_node_or_null("/root/Game/Map")

func _ready() -> void:
	connect("difficulty_changed",debug_gui,"_on_difficulty_changed")
	EventBus.connect("max_enemy_count_change",self,"_on_max_enemy_count_change")
	max_enemys = SaveManager.current_save_options["max_enemy_count"]

func _process(delta) -> void:
	if !game_alive:
		return
	handle_enemy_spawning(delta)
	handle_item_spawning(delta)

func _on_max_enemy_count_change(new_count:int)->void:
	max_enemys=new_count

#-----------Spawning Routine-------------
##Handles the automatic spawning of items on the map
func handle_item_spawning(delta)->void:
	item_spawn_value += item_spawn_rate*delta
	while (item_spawn_value >= 1):
		item_spawn_value -=1
		spawn_rand_item_at(random_position_in_map())

##Spawns a random item at a given global position
func spawn_rand_item_at(pos)->void:
	#spawn_at(item_array[randi()%len(item_array)],pos)
	spawn_at(get_random_item(),pos)

##Spawns a random item at a given position with a certain propability
func spawn_rand_item_at_prob(prob,pos)->void:
	if randf() <= prob:
		spawn_rand_item_at(pos)

func handle_enemy_spawning(delta)->void:
	#change spawn probability over time
	enemy_spawn_rate += delta*enemy_spawn_rate_increase
	enemy_damage_mult += delta*enemy_damage_increase
	enemy_health_mult += delta*enemy_health_increase
	enemy_speed_mult += delta*enemy_speed_increase
	emit_signal("difficulty_changed",enemy_health_mult,enemy_damage_mult,enemy_speed_mult,enemy_view_range_mult,enemy_spawn_rate)

	#decides how many enemys are supposed to spawn
	enemy_spawn_value+= enemy_spawn_rate*delta
	if game.enemys_alive >= max_enemys:
		return
	while (enemy_spawn_value >= 1):
		enemy_spawn_value -= 1
		#game.enemys_alive+=1
		spawn_at(default_enemy,random_position_out_map(),true,true)
		if game.enemys_alive >= max_enemys:
			return

func spawn_at(scene:PackedScene,pos:Vector2,is_enemy:bool=false,apply_difficulty:bool=false)->void:
	if is_enemy:
		game.enemys_alive+=1
	call_deferred("_spawn_at",scene,pos,apply_difficulty)


func _spawn_at(scene,pos,apply_difficulty=false):
	var _obj = scene.instance()
	_obj.global_position = pos
	game.add_child(_obj)
	if apply_difficulty and _obj.is_in_group("ENEMIES"):
		_obj.set_damage(_obj.damage * enemy_damage_mult)
		_obj.set_speed(_obj.speed * enemy_speed_mult)
		_obj.set_max_health(_obj.max_health * enemy_speed_mult)
	emit_signal("spawned_enemy")

func spawn(scene):
	var _obj = scene.instance()
	game.add_child(_obj)
	return _obj

##Needed for effect fo standard rifle
func mult_all_weapon_probs(factor:float) -> void:
	for item in item_array:
		if "weapon" in item._bundled["names"][2]:
			var lh:float = get_item_spawn_lh(item)
			#inefficient for many items because calc_item_probs get called after every change
			set_item_spawn_prob(item,lh*factor)

#-----------Helpers for Spawning routine -------------
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


func set_map_size(x_size:float,y_size:float)->void:
	map_size_x = x_size/2
	map_size_y = y_size/2

#-----------Needed for random item-------------

func get_random_item():
	if item_probs == []:
		calc_item_probs()
	var _item = item_array[item_probs.bsearch(randf())]
	return _item

##Uses the array of likelihoods to create item_probs wich is used to retrieve a random item
func calc_item_probs() -> void:
	var start:float = 0
	if len(item_array) != len (item_likelihood):
		print_debug("ERROR: AMOUNT OF LIKELIHOODS DOES NOT EQUAL AMOUNT OF ITEMS IN SPAWNER")
		return

	var new_item_probs:Array=[]
	var total:float = float(sum(item_likelihood))

	for item_like in item_likelihood:
		var prob:float =float(item_like)/total
		new_item_probs.append(start + prob)
		start +=prob

	item_probs = new_item_probs

func changed_likelihood(new_likelihoods) -> void:##Recalculates the item_probs after chenge in item_likeliehoods
	item_likelihood = new_likelihoods
	calc_item_probs()

func get_item_spawn_lh(item) -> float:
	return item_likelihood[item_array.find(item)]

func set_item_spawn_prob(item,new_lh) -> void:
	item_likelihood[item_array.find(item)] = new_lh
	calc_item_probs()

func sum(int_array:Array)-> int:
	var res:int = 0
	for el in int_array:
		res += el
	return res

