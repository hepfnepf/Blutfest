extends Node

signal music_player_set

enum DamageType{PROJECTILE,EXPLOSION}
enum Rarity{COMMON,NORMAL,RARE,LEGENDARY}
enum CrosshairType{CROSSHAIR,CONE,BOTH}
enum InputMode{CONTROLLER,KEYBOARD_MOUSE, TOUCH}

var first_start:bool=false
var android:bool=false
var last_input_mode:int= InputMode.KEYBOARD_MOUSE


var cursor_manager = null
var music_player = null setget set_music_player #this var gets set by the background music node using set_music_player
var game = null

#Controller focus management
var controller_focus_stack = []

func _ready() -> void:
	cursor_manager = load("res://Scripts/Cursor.gd").new()

func set_music_player(_music_player:AudioStreamPlayer)->void:
	music_player = _music_player
	emit_signal("music_player_set")

func _input(event)->void:
	if event.get_class() in ["InputEventJoypadButton","InputEventJoypadMotion"]:
		set_last_input_mode(InputMode.CONTROLLER)
	elif event.get_class() in ["InputEventScreenTouch", "InputEventScreenDrag"]:
		set_last_input_mode(InputMode.TOUCH)
	else:
		set_last_input_mode(InputMode.KEYBOARD_MOUSE)

func set_last_input_mode(mode:int)->void:
	if last_input_mode != mode:
		last_input_mode = mode
		print_debug("New input mode: ", last_input_mode)

#Handling controller focus
func get_super_focus()->Node:
	controller_focus_stack.pop_back() # this is the calling element, it should be removed and its superior focus object returned
	var super = null
	while not is_instance_valid(super):
		super = controller_focus_stack.pop_back()
		if super==null:
			break
	return super

func add_focus_element(element)->void:
	controller_focus_stack.push_back(element)
