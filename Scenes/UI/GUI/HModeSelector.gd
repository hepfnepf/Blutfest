tool
extends HBoxContainer

signal modeSwitched(mode)

export(String) var initText = "" setget set_init_text
export(Array)  var modes = []

var ind: = -1 setget set_index

func _ready()->void:
	set_mode(initText)

func get_mode()->String:
	return modes[ind]

func set_mode(mode:String)->void:
	var index = modes.find(mode)
	if index != -1:
		set_index(index)

func set_index(index:int)->void:
	var prev_ind = ind 
	ind = int(clamp(index,0,modes.size()-1))
	if ind != prev_ind:
		$"%ModeTypeLabel".text=modes[ind]
		emit_signal("modeSwitched",modes[ind])

func set_init_text(text:String)->void:
	set_mode(text)
	initText = text

func set_neighbour_below(path:NodePath)->void:
	for child in get_children():
		child.focus_neighbour_bottom=path

func _on_ModeSwitchButtonLeft_pressed():
	set_index(ind-1)

func _on_ModeSwitchButtonRight_pressed():
	set_index(ind+1)
