extends Control
class_name PauseMenu

onready var credits = $CreditsScreen

var blocked := false


func _input(event):
	if Input.is_action_just_pressed("Escape") and !blocked:
		switch_state()
		# Pause game


func switch_state():
	get_tree().paused = !get_tree().paused
	visible = !visible
	if credits.visible:
		credits.visible = false

	#Change Cursor
	if Globals.cursor_manager.cursor == Cursor.CURSOR_TYPE.CROSSHAIR:
		Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	else:
		Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR)


func _on_ReturnButton_pressed():
	switch_state()


func _on_OptionsButton_pressed():
	pass # Replace with function body.


func _on_CreditsButton_pressed():
	if is_instance_valid(credits):
		credits.visible = true


func _on_ExitButton_pressed():
	get_tree().quit()

func _on_Player_Death(): # gets connected in GUI
	blocked = true
	print("dddddddddd")
