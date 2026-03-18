tool
extends HBoxContainer

signal value_changed(value)

export(String) var text = "" setget set_setxt
export(bool)var show_controller=true
export(bool)var show_keyboard=true

onready var slider = $"%DeadzoneSlider"

func set_setxt(text:String)->void:
	$Label.text=text

func set_mode_by_string(mode:String)->void:
	if mode=="KEYBOARD" and !show_keyboard:
		visible=false
	elif mode=="CONTROLLER" and !show_controller:
		visible=false
	else:
		visible=true

func _on_DeadzoneSlider_value_changed(value):
	emit_signal("value_changed",value)
