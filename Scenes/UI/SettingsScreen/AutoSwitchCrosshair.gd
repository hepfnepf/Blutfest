tool
extends HBoxContainer

export(String)var label setget set_label
export(String)var default_option_text setget set_default_text

var options = {"CROSSHAIR":Globals.CrosshairType.CROSSHAIR,
				"CONE":Globals.CrosshairType.CONE,
				"BOTH":Globals.CrosshairType.BOTH}

onready var btn:OptionButton = $"%OptionButton"
onready var checkbox:CheckBox= $"%CheckBox"

func _ready():
	for option in options:
		btn.add_item(option,options[option])

func set_default_text(text:String)->void:
	$"%OptionButton".text=default_option_text
	default_option_text=text

func set_label(text:String)->void:
	$Label.text=text
	label=text

func set_enabled(enabled:bool)->void:
	checkbox.pressed = enabled

func get_is_enabled()->bool:
	return checkbox.pressed

func set_value(mode:int)->void:
	btn.select(btn.get_item_index(mode))

func get_value()->int:
	return btn.get_item_id(btn.selected)
