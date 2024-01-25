extends Popup


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("toogle_help") and visible:
		hide()

	elif Input.is_action_just_pressed("toogle_help") and !visible and !get_tree().paused:#game should not be in main menu or card selection
		popup()


func _on_InstructionsPopup_about_to_show() -> void:
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	get_tree().paused = true


func _on_InstructionsPopup_popup_hide() -> void:
	get_tree().paused = false
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR)
