extends Node

enum DamageType{PROJECTILE}

var cursor_manager = null

func _ready():
	cursor_manager = load("res://Scripts/Cursor.gd").new()
