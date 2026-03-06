extends Tabs

export(NodePath) var first_focus_element
export(NodePath) var last_focus_element

onready var exit_button:Node=get_parent().get_parent().get_node("ExitButton")


func set_last_element()->void:
	get_node(last_focus_element).focus_neighbour_bottom = exit_button.get_path()
	get_node(last_focus_element).focus_next = exit_button.get_path()
	
	exit_button.focus_neighbour_top = realtive_to_absolute_path(last_focus_element)
	exit_button.focus_previous = realtive_to_absolute_path(last_focus_element)


## The paths are basically just strings
## Relative paths from this node as base to an other cannot be used to adress the same target node from a different node
func realtive_to_absolute_path(path:NodePath) -> NodePath:
	return get_node(path).get_path()

