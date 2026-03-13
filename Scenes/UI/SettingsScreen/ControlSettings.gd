extends "res://Scenes/UI/SettingsScreen/ExtendedTabs.gd"

onready var zoom_inverted_toggle_button:CheckBox = $"%CheckBox"
onready var button_container:GridContainer = $MarginContainer/VBoxContainer/GridContainer
onready var mode_selector = $MarginContainer/VBoxContainer/HModeSelector

func _ready():
	if Globals.android:
		queue_free()
	mode_selector.connect("modeSwitched",self,"_on_HModeSelector_modeSwitched")
	

func _on_HModeSelector_modeSwitched(mode:String):
	for child in button_container.get_children():
		print_debug(child.get_class())
		if child.has_method("set_mode_by_string"):
			child.set_mode_by_string(mode)
