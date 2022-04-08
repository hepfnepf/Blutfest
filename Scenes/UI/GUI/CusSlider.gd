tool
extends VBoxContainer

onready var button:Button = $Button

export (Texture) var button_texture = null

func _ready() -> void:
	if is_instance_valid(button):
		button.icon = button_texture

func set_texture(_texture:Texture)->void:
	if is_instance_valid(button):
		button.icon = button_texture
