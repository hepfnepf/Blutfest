extends "res://Scenes/UI/GUI/TouchableButton.gd"


#Since pausing is already handled using the escape action, this simply triggers the action

func _on_PauseButton_button_down():
	var pauseEvent:InputEventAction = InputEventAction.new()
	pauseEvent.action = "Escape"
	pauseEvent.pressed = true
	Input.parse_input_event(pauseEvent)
	print_debug("Pressed Escape!")
	call_deferred("resetEscapeKey")

func resetEscapeKey() -> void:
	var pauseEvent:InputEventAction = InputEventAction.new()
	pauseEvent.action = "Escape"
	pauseEvent.pressed = false
	Input.parse_input_event(pauseEvent)
	print_debug("Unpressed Escape!")

func _on_Button_pressed()->void:
	_on_PauseButton_button_down()
