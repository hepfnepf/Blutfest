extends Node
class_name Perk

export (String) var title = "" setget ,get_title
export (String) var desc = "" setget ,get_desc
export (Texture) var icon= null
export (bool) var one_time = false

export (Array,PackedScene) var required
export (Array,PackedScene) var blocks
export (int)var min_level = 0

onready var player:Player = get_parent()

func add_effect()->void:
	pass

func remove_effect()->void:
	pass

func get_title()->String:
	return tr(title)

func get_desc()->String:
	return tr(desc)

func _ready()->void:
	add_effect()
