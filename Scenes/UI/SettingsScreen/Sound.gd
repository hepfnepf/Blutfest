extends "res://Scenes/UI/SettingsScreen/ExtendedTabs.gd"

func set_last_element()->void:
	get_node(last_focus_element).focus_neighbour_bottom = exit_button.get_path()
	get_node(last_focus_element).focus_next = exit_button.get_path()
	get_node(first_focus_element).focus_neighbour_bottom = exit_button.get_path()
	
	var last_node = get_node(last_focus_element)
	exit_button.focus_neighbour_top = realtive_to_absolute_path(last_node.get_child(1).get_path()) # it has to be the button, not the parent scenen
	exit_button.focus_previous = realtive_to_absolute_path(last_node.get_child(1).get_path())
