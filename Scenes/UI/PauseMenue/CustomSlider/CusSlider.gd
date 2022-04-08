tool
extends VBoxContainer

onready var button:Button = $Button
onready var slider:Slider = $VSlider

export (Texture) var button_texture = null

func _ready() -> void:
	if is_instance_valid(button):
		button.icon = button_texture

func set_texture(_texture:Texture)->void:
	if is_instance_valid(button):
		button.icon = button_texture


func _on_VSlider_value_changed(value):
	pass # Replace with function body.
