tool
extends HBoxContainer
class_name RebindRow

export(String)var label_text setget set_text
export(String)var rebind_action
export(bool)var show_controller=true
export(bool)var show_keyboard=true


func _ready():
	$"%RebindActionLabel".text=label_text
	$"%RebindButton".rebind_action=rebind_action

func set_text(text)->void:
	$"%RebindActionLabel".text=label_text
	label_text=text

func set_mode_by_string(mode:String)->void:
	if mode=="KEYBOARD" and !show_keyboard:
		visible=false
	elif mode=="CONTROLLER" and !show_controller:
		visible=false
	else:
		visible=true
	$"%RebindButton".set_mode_by_string(mode)
