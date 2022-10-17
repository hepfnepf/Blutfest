extends Node

signal music_player_set

enum DamageType{PROJECTILE,EXPLOSION}

var cursor_manager = null
var music_player = null setget set_music_player #this var gets set by the background music node using set_music_player

func _ready() -> void:
	cursor_manager = load("res://Scripts/Cursor.gd").new()

func set_music_player(_music_player:AudioStreamPlayer)->void:
	music_player = _music_player
	emit_signal("music_player_set")
