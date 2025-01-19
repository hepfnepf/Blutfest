#tool
extends "res://Scenes/UI/PauseMenue/CustomSlider/CusSlider.gd"

"""
Allows you to select a channel and maipulate its volume with the slider.
"""

export (String) var audio_channel = "Master"
export (Texture) var button_texture_disabled = null


onready var bus_index:int = AudioServer.get_bus_index(audio_channel)
onready var toggle_button:Button=$Button


var has_chagend:bool = false
var changed_by_code:bool= false

func _ready() -> void:
	._ready()
	set_to_current_volume()
	set_to_current_mute()

func _process(_delta: float) -> void:
	set_to_current_volume()
	set_to_current_mute()

func set_to_current_volume()->void:
	value_change_code(db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(audio_channel))))

func set_to_current_mute()->void:
	toggle_button.pressed = AudioServer.is_bus_mute(bus_index)

func value_change_code(value:float)->void:#wrapper  in case the vslider value gets changed by code, to differentiate it from user input, gets linear value
	changed_by_code = true
	slider.value = value

func _on_VSlider_value_changed(value:float):#gets linear value
	var db_value = linear2db(value)

	AudioServer.set_bus_volume_db(bus_index, db_value)
	if !changed_by_code:
		button.pressed = false
	else:
		changed_by_code=false
	has_chagend = true

func _on_Button_toggled(button_pressed:bool):
	if button_pressed:
		AudioServer.set_bus_mute(bus_index,true)
		button.icon = button_texture_disabled
	else:
		AudioServer.set_bus_mute(bus_index,false)
		button.icon = button_texture
	has_chagend=true
