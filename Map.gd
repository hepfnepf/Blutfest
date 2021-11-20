extends Node2D
class_name Map

onready var x_size:float = $Texture.texture.get_width() * $Texture.scale.x
onready var y_size:float = $Texture.texture.get_height() * $Texture.scale.y

signal set_size(x_size,y_size)#the spawner connects to this signal so it gets the boundarys of the map set

func _ready():
	emit_signal("set_size",x_size/2.0,y_size/2.0)
