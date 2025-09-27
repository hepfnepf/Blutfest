extends Node2D

const INACTIVE_IDX = -1;
export var AnalogTapToShow = false setget set_tap_to_show
export var AnalogTapToShowContainer = ""
export var mapAnalogToDpad = true

onready var ball = $ball
onready var animation_player = $AnimationPlayer
onready var halfSize = $bg.texture.get_size()/2

var centerPoint:Vector2 = Vector2(0,0)
var currentForce:Vector2 = Vector2(0,0)
var ballPos = Vector2()
var squaredHalfSizeLength:float = 0
var currentPointerIDX:int = INACTIVE_IDX;
var debug_name = ""


func _ready():
	if AnalogTapToShowContainer == "":
		AnalogTapToShowContainer = get_parent()

	map_analog_dpad()
	set_process_input(true)
	squaredHalfSizeLength = halfSize.x * halfSize.y

func get_force():
	return currentForce

func _input(event):
	var incomingPointer = extractPointerIdx(event)
	if incomingPointer == INACTIVE_IDX:
		return

	if need2ChangeActivePointer(event):
		if (currentPointerIDX != incomingPointer) and event.is_pressed():
			currentPointerIDX = incomingPointer;
			print_debug(debug_name, "PointerIdx: ", currentPointerIDX)
			showAtPos(Vector2(event.position.x, event.position.y));

	var theSamePointer = currentPointerIDX == incomingPointer
	if isActive() and theSamePointer:
		process_input(event)

func need2ChangeActivePointer(event): #touch down inside analog
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if AnalogTapToShow:
			return AnalogTapToShowContainer.get_global_rect().has_point(Vector2(event.position.x, event.position.y))
		else:
			var length = (global_position - Vector2(get_global_event_position(event.position).x, get_global_event_position(event.position).y)).length_squared();
			return length < squaredHalfSizeLength
	else:
		return false

func isActive():
	return currentPointerIDX != INACTIVE_IDX

func extractPointerIdx(event):
	var touch = event is InputEventScreenTouch
	var drag = event is InputEventScreenDrag
	var mouseButton = event is InputEventMouseButton
	var mouseMove = event is InputEventMouseMotion

	if touch or drag:
		return 1
	elif mouseButton or mouseMove:
		return 0
	else:
		return INACTIVE_IDX

func process_input(event:InputEvent):
	
	calculateForce(get_global_event_position(event.position).x - global_position.x, get_global_event_position(event.position).y - global_position.y)
	updateBallPos()
		
	var isReleased = isReleased(event)
	if isReleased:
		print_debug(debug_name, " released")
		reset()


func reset():
	currentPointerIDX = INACTIVE_IDX
	calculateForce(0, 0)
	sendSignal2Listener()

	if AnalogTapToShow:
		hide()
	else:
		updateBallPos()

func showAtPos(pos):
	if AnalogTapToShow:
		animation_player.play("alpha_in", 0.2)
		global_position = pos

func hide():
	animation_player.play("alpha_out", 0.2)

func updateBallPos():
	ballPos.x = halfSize.x * currentForce.x #+ halfSize.x
	ballPos.y = halfSize.y * -currentForce.y #+ halfSize.y
	ball.position = Vector2(ballPos.x, ballPos.y)

func isPressed(event):
	if event is InputEventMouseMotion:
		return (event.button_mask == 1)
	elif event is InputEventScreenTouch:
		return event.is_pressed()

func isReleased(event):
	if event is InputEventScreenTouch:
		return !event.is_pressed()
	elif event is InputEventMouseButton:
		return !event.is_pressed()

func calculateForce(var x, var y):
	#get direction
	currentForce.x = (x - centerPoint.x)/halfSize.x
	currentForce.y = -(y - centerPoint.y)/halfSize.y
	if currentForce.length_squared()>1:
		currentForce=currentForce/currentForce.length()

	sendSignal2Listener()

func set_tap_to_show(value):
	if value:
		modulate.a = 0

		if not AnalogTapToShowContainer is ViewportContainer:
			assert(
				AnalogTapToShowContainer is ViewportContainer,
				"To use tag AnalogDynamicShowing you need to put GamePad inside a ViewportContainer"
			)

	AnalogTapToShow = value

func print_debug_event(event:InputEvent) -> void:
	print_debug(debug_name, ":",event)
	if event is InputEventMouse:
		return
	var out = String(event.index)+ "\n" +String (event.is_pressed()) +"\n"+ String(event.device )+ "\n"
	print_debug(out)
#converts from event.position to global position
#https://www.reddit.com/r/godot/comments/gj4yev/convert_eventposition_mouse_to_local_position_in/
func get_global_event_position(event_position:Vector2)->Vector2:
	return get_canvas_transform().affine_inverse().xform(event_position)

func sendSignal2Listener():
	#get_tree().call_group("JoyStick", "analog_signal_change", currentForce, self.get_name())
	
	if mapAnalogToDpad:
		map_analog_dpad()
	else:
		map_anlog_to_joystick()

func map_analog_dpad():
	Input.action_press("move_left") if currentForce.x < -0.2 else Input.action_release("move_left")
	Input.action_press("move_right") if currentForce.x > 0.2 else Input.action_release("move_right")
	Input.action_press("move_down") if currentForce.y < -0.2 else Input.action_release("move_down")
	Input.action_press("move_up") if currentForce.y > 0.2 else Input.action_release("move_up")

func map_anlog_to_joystick():
#	print_debug(currentForce)
	Input.action_press("move_left",abs(currentForce.x)) if currentForce.x < -0.2  else Input.action_release("move_left")
	Input.action_press("move_right",abs(currentForce.x)) if currentForce.x > 0.2  else Input.action_release("move_right")
	Input.action_press("move_down",abs(currentForce.y)) if currentForce.y < -0.2  else Input.action_release("move_down")
	Input.action_press("move_up",abs(currentForce.y)) if currentForce.y > 0.2  else Input.action_release("move_up")
