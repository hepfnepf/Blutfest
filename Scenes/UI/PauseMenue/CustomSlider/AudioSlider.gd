#tool
extends "res://Scenes/UI/PauseMenue/CustomSlider/CusSlider.gd"

"""
Allows you to select a channel and maipulate its volume with the slider.
"""

export (String) var audio_channel = "Master"

export (Texture) var button_texture_disabled = null

var has_chagend:bool = false

var changed_by_code= false

func _ready() -> void:
	._ready()
	value_change_code(db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_channel))))

func set_to_current_volume():
	value_change_code(db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_channel))))

func value_change_code(value):#wrapper  in case the vslider value gets changed by code, to differentiate it from user input, gets linear value
	changed_by_code = true
	slider.value = value

func _on_VSlider_value_changed(value):#gets linear value
	var sfx_index= AudioServer.get_bus_index(audio_channel)
	var db_value = linear2db(value)

	AudioServer.set_bus_volume_db(sfx_index, db_value)
	if !changed_by_code:
		button.pressed = false
	else:
		changed_by_code=false
	has_chagend = true

func _on_Button_toggled(button_pressed):
	var sfx_index= AudioServer.get_bus_index(audio_channel)
	if button_pressed:
		AudioServer.set_bus_volume_db(sfx_index, linear2db(0))
		button.icon = button_texture_disabled
	else:
		AudioServer.set_bus_volume_db(sfx_index, linear2db(slider.value))
		button.icon = button_texture
	has_chagend=true
