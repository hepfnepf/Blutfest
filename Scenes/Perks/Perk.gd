extends Node
class_name Perk

export (String) var title = ""
export (String) var desc = ""
export (Texture) var icon= null

export (Array,PackedScene) var required
export (Array,PackedScene) var blocks

onready var player:Player = get_parent()

func add_effect()->void:
	pass

func remove_effect()->void:
	pass

func _ready()->void:
	add_effect()
