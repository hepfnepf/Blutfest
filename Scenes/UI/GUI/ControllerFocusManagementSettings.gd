extends ControllerFocusManagement

func receive_focus():
	Globals.add_focus_manager(self)
	var index:int = $"%TabContainer".current_tab
	_on_TabContainer_tab_selected(index)

func _on_TabContainer_tab_selected(tab_index:int):
	var tab =$"%TabContainer".get_child(tab_index)
	tab.set_last_element()
	var path:NodePath =  tab.first_focus_element
	var node:Node = tab.get_node_or_null(path)
	
	if is_instance_valid(node):
		if node.has_method("receive_focus"):
			node.receive_focus()
		elif node.has_method("grab_focus"):
			node.grab_focus()
	else:
		print_debug("No focus object.")
