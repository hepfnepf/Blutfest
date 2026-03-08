extends "res://Scenes/UI/SettingsScreen/ExtendedTabs.gd"

onready var language_grid = $MarginContainer/GridContainer

func _ready() -> void:
	var locale:String = SaveManager.current_save_options["language"]
	if locale != "":
		TranslationServer.set_locale(SaveManager.current_save_options["language"])

	for child in language_grid.get_children():
		child.connect("new_language_selected",self,"_new_language_selected")

func _new_language_selected(flag)->void:
	#Actual language gets set in the flags code
	for child in language_grid.get_children():
		if child != flag:
			child.detoggle()

func toggle_on_current_language()->void:
	pass


func set_last_element()->void:
	var node = get_node(first_focus_element)
	exit_button.focus_neighbour_top = realtive_to_absolute_path(node.get_child(0).get_path()) # it has to be the button, not the parent scenen
	exit_button.focus_previous = realtive_to_absolute_path(node.get_child(0).get_path())
