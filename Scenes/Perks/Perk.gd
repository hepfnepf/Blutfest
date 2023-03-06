extends Node
class_name Perk

onready var player:Player = get_parent()

func add_effect()->void:
	pass

func remove_effect()->void:
	pass

func _ready()->void:
	add_effect()
