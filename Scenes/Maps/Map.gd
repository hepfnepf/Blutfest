extends Node2D
class_name Map

onready var x_size:float = $Texture.texture.get_width() * $Texture.scale.x
onready var y_size:float = $Texture.texture.get_height() * $Texture.scale.y

func get_map_size()->Vector2:
	return Vector2(x_size,y_size)
