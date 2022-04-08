tool
extends "res://Scenes/UI/PauseMenue/CustomSlider/CusSlider.gd"

"""
Allows you to select a channel and maipulate its volume with the slider.
"""

export (String) var audio_channel = "Master"



func _ready() -> void:
	._ready()
	slider.value = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_channel)))

func _on_VSlider_value_changed(value):
	var sfx_index= AudioServer.get_bus_index(audio_channel)
	var db_value = linear2db(value)
	AudioServer.set_bus_volume_db(sfx_index, db_value)
