extends Node

signal music_player_set

enum DamageType{PROJECTILE,EXPLOSION}
enum Rarity{COMMON,NORMAL,RARE,LEGENDARY}
enum CrosshairType{CROSSHAIR,CONE,BOTH}
enum InputMode{CONTROLLER,KEYBOARD_MOUSE, TOUCH}

var first_start:bool=false
var android:bool=false
var last_input_mode:int= InputMode.KEYBOARD_MOUSE
var is_paused_by_menu:bool = false


var cursor_manager = null
var music_player = null setget set_music_player #this var gets set by the background music node using set_music_player
var game = null

func _ready() -> void:
	cursor_manager = load("res://Scripts/Cursor.gd").new()

func set_music_player(_music_player:AudioStreamPlayer)->void:
	music_player = _music_player
	emit_signal("music_player_set")

func _input(event)->void:
	switch_input_mode_by_event(event)

func switch_input_mode_by_event(event:InputEvent)->void:
	if event.get_class() in ["InputEventJoypadButton","InputEventJoypadMotion"]:
		set_last_input_mode(InputMode.CONTROLLER)
	elif event.get_class() in ["InputEventScreenTouch", "InputEventScreenDrag"]:
		set_last_input_mode(InputMode.TOUCH)
	elif event.get_class() in ["InputEventMouseButton","InputEventKey"]:
		set_last_input_mode(InputMode.KEYBOARD_MOUSE)

func set_last_input_mode(mode:int)->void:
	if last_input_mode != mode:
		last_input_mode = mode
		EventBus.emit_signal("input_type_changed",mode)
