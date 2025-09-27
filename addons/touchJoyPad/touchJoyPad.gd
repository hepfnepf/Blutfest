extends Node2D

export(String, "D-Pad", "JoyStick") var PadStyle
export var mapAnalogToDpad = true
export var visibleOnlyTouchscreen = true
export var AnalogTapToShow = false
export var DebugName = ""

func _ready():
	var toEnable = "DPad" if PadStyle=="D-Pad" else "JoyStick"
	var toDisable = "JoyStick" if PadStyle=="D-Pad" else "DPad"
	enable_gamepad(toEnable)
	disable_gamepad(toDisable)
	
	if visibleOnlyTouchscreen and not OS.has_touchscreen_ui_hint():
		disable_gamepad("DPad")
		disable_gamepad("JoyStick")

func enable_gamepad(node):
	get_node(node).visible = true
	get_node(node).position = Vector2(0, 0)
	get_node(node).debug_name = DebugName
	
func disable_gamepad(node):
	get_node(node).visible = false
	get_node(node).position = Vector2(-1000, -1000)
