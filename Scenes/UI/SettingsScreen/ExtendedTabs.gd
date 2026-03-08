extends Tabs

export(NodePath) var first_focus_element
export(NodePath) var overwrite_last_focus_element

onready var exit_button:Node=get_parent().get_parent().get_node("ExitButton")

func _ready()->void:
	$"%TabContainer".connect("tab_changed",self,"_on_TabContainer_tab_selected")

func set_last_element()->void:	
	if get_node_or_null(overwrite_last_focus_element) != null:
		get_node(overwrite_last_focus_element).focus_neighbour_bottom = exit_button.get_path()
		get_node(overwrite_last_focus_element).focus_next = exit_button.get_path()
		
		exit_button.focus_neighbour_top = realtive_to_absolute_path(overwrite_last_focus_element)
		exit_button.focus_previous = realtive_to_absolute_path(overwrite_last_focus_element)


## The paths are basically just strings
## Relative paths from this node as base to an other cannot be used to adress the same target node from a different node
func realtive_to_absolute_path(path:NodePath) -> NodePath:
	return get_node(path).get_path()

func _on_TabContainer_tab_selected(tab_index:int):
	   var tab =$"%TabContainer".get_child(tab_index)
	   tab.set_last_element()
	   var path:NodePath =  tab.first_focus_element
	   var node:Node = tab.get_node_or_null(path)

	   if is_instance_valid(node):
			   if node.has_method("grab_focus"):
					   node.grab_focus()
	   else:
			   print_debug("No focus object.")
