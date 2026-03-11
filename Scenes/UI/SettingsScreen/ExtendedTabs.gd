extends Tabs

export(NodePath) var first_focus_element

onready var exit_button:Node=get_parent().get_parent().get_node("ExitButton")

func _ready()->void:
	$"%TabContainer".connect("tab_changed",self,"_on_TabContainer_tab_selected")

func _on_TabContainer_tab_selected(tab_index:int):
	var tab =$"%TabContainer".get_child(tab_index)
	var path:NodePath =  tab.first_focus_element
	var node:Node = tab.get_node_or_null(path)
	if is_instance_valid(node):
		if node.has_method("grab_focus"):
			node.grab_focus()
		else:
			print_debug("The node selected as focus node can not receive focus.")
	else:
		print_debug("No focus object.")
