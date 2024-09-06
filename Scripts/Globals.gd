extends Node

signal music_player_set
signal zooming_inverted(zooming_inv)

enum DamageType{PROJECTILE,EXPLOSION}
enum Rarity{COMMON,NORMAL,RARE,LEGENDARY}

var cursor_manager = null
var music_player = null setget set_music_player #this var gets set by the background music node using set_music_player
var game = null

var zooming_inverted:bool=false setget set_zooming_inverted

func _ready() -> void:
	cursor_manager = load("res://Scripts/Cursor.gd").new()

func set_music_player(_music_player:AudioStreamPlayer)->void:
	music_player = _music_player
	emit_signal("music_player_set")

func set_zooming_inverted(zooming_inv:bool)->void:
	zooming_inverted = zooming_inv
	emit_signal("zooming_inverted", zooming_inv)
