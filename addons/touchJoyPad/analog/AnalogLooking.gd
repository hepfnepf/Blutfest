extends "res://addons/touchJoyPad/analog/analog.gd"

export(float) var min_force = 0.0#deadzone

func handle_possible_state_change(event:InputEvent)->void:
	var was_inactive = state == input_state.INACTIVE
	.handle_possible_state_change(event)
	if was_inactive and state != input_state.INACTIVE:
		Input.action_press("fire")

func reset():
	.reset()
	Input.action_release("fire")


func sendSignal2Listener():
	#get_tree().call_group("JoyStick", "analog_signal_change", currentForce, self.get_name())
	if currentForce.length_squared() > min_force*min_force:
		map_anlog_to_joystick()

func map_analog_dpad():
	Input.action_press("looking_left") if currentForce.x < -0.2 else Input.action_release("looking_left")
	Input.action_press("looking_right") if currentForce.x > 0.2 else Input.action_release("looking_right")
	Input.action_press("looking_down") if currentForce.y < -0.2 else Input.action_release("looking_down")
	Input.action_press("looking_up") if currentForce.y > 0.2 else Input.action_release("looking_up")

func map_anlog_to_joystick():
	Input.action_press("looking_left",abs(currentForce.x)) if currentForce.x < 0  else Input.action_release("looking_left")
	Input.action_press("looking_right",abs(currentForce.x)) if currentForce.x > 0  else Input.action_release("looking_right")
	Input.action_press("looking_down",abs(currentForce.y)) if currentForce.y < 0 else Input.action_release("looking_down")
	Input.action_press("looking_up",abs(currentForce.y)) if currentForce.y > 0  else Input.action_release("looking_up")

