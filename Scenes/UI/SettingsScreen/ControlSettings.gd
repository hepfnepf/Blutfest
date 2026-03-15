extends "res://Scenes/UI/SettingsScreen/ExtendedTabs.gd"

onready var zoom_inverted_toggle_button:CheckBox = $"%CheckBox"
onready var button_container:VBoxContainer = $MarginContainer/VBoxContainer/GridContainer
onready var mode_selector = $MarginContainer/VBoxContainer/HModeSelector
onready var deadzone_movement:Slider = $"%DeadzoneMovementSlider"

func _ready():
	if Globals.android:
		queue_free()
	mode_selector.connect("modeSwitched",self,"_on_HModeSelector_modeSwitched")
	set_mode(mode_selector.get_mode())
	mode_selector.set_neighbour_below(get_node(first_focus_element).get_path())
	load_deadzones()

func set_mode(mode:String)->void:
	for child in button_container.get_children():
		if child.has_method("set_mode_by_string"):
			child.set_mode_by_string(mode)

func load_deadzones()->void:
	var saveGame = SaveManager.get_options_save()
	deadzone_movement.value = saveGame["deadzone_walking"]

func _on_HModeSelector_modeSwitched(mode:String):
	set_mode(mode)

func _on_DeadzoneMovementSlider_value_changed(value):
	EventBus.emit_signal("deadzone_walking_changed", value)
