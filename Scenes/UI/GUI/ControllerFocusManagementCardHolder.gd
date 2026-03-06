extends ControllerFocusManagement


## There can be a special case for the card holder
## In wich the focus is received, while the pause menu and its sub windows
## are already open. This is, because the card holder does not care that the game is paused.
## Which makes sense, as it pauses the game itself on perk selection.
## And obviously its own code still needs to run when the gametree itself is paused.
## This leads to the the problem that the pause menu focus manager is below the cards menu focus manager
## while the pause menu gui is on top of the card holder gui. And the ui_cancel action cannot
## close the pause menu, since its not the current focus holder.
## So instead, the card manager pushes itself to the lowest point of the stack.
## This makes sense, as currently nothing else could logicaly need this spot.
func receive_focus():
	Globals.add_focus_manager_front(self)
	if Globals.is_paused_by_menu:
		return
	
	
	if is_instance_valid(focus_object):
		if focus_object.has_method("receive_focus"):
			focus_object.receive_focus()
		elif focus_object.has_method("grab_focus"):
			focus_object.grab_focus()
	else:
		print_debug("No focus object.")
