extends "res://addons/touchJoyPad/analog/analog.gd"


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
