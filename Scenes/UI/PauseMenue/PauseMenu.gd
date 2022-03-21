extends Control
class_name PauseMenu



func _input(event):
	if Input.is_action_just_pressed("Escape"):
		switch_state()
		# Pause game
		

func switch_state():
	get_tree().paused = !get_tree().paused
	if Globals.cursor_manager.cursor == Cursor.CURSOR_TYPE.CROSSHAIR:
		Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT) 
	else:
		Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR) 
	visible = !visible

func _on_ReturnButton_pressed():
	switch_state()


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_CreditsButton_pressed():
	pass # Replace with function body.


func _on_ExitButton_pressed():
	get_tree().quit()
