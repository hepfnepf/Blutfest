extends Node2D
class_name Map

onready var xsize = $Texture.texture.get_width() * $Texture.scale.x
onready var ysize = $Texture.texture.get_height() * $Texture.scale.y

func _ready():
	print_debug(xsize)

