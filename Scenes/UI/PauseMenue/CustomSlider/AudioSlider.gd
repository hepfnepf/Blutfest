tool
extends "res://Scenes/UI/PauseMenue/CustomSlider/CusSlider.gd"

"""
Allows you to select a channel and maipulate its volume with the slider.
"""

export (String) var audio_channel = "Master"

export (Texture) var button_texture_disabled = null

func _ready() -> void:
	._ready()
	slider.value = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_channel)))

func _on_VSlider_value_changed(value):
	var sfx_index= AudioServer.get_bus_index(audio_channel)
	var db_value = linear2db(value)
	AudioServer.set_bus_volume_db(sfx_index, db_value)
	button.pressed = false

func _on_Button_toggled(button_pressed):
	var sfx_index= AudioServer.get_bus_index(audio_channel)
	if button_pressed:
		AudioServer.set_bus_volume_db(sfx_index, linear2db(0))
		button.icon = button_texture_disabled
	else:
		AudioServer.set_bus_volume_db(sfx_index, linear2db(slider.value))
		button.icon = button_texture
