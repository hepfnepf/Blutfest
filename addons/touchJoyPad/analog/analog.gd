extends Node2D

onready var ball:Sprite = $ball
onready var animation_player:AnimationPlayer = $AnimationPlayer
onready var halfSize:Vector2 = $bg.texture.get_size()/2

var centerPoint:Vector2 = Vector2(0,0)
var currentForce:Vector2 = Vector2(0,0)
var ballPos = Vector2()
var squaredHalfSizeLength:float = 0 #gets sets in _ready

var debug_name:String = ""
var state = input_state.INACTIVE
var touch_id:int = 0#makes it able to see if multiple touch event belong to the same finger stroke

# Virtual joystick

func _ready()-> void:
	set_process_input(true)
	squaredHalfSizeLength = halfSize.x * halfSize.y

func get_force():
	return currentForce

func _input(event:InputEvent) -> void:
	handle_possible_state_change(event)
	handle_movement(event)

func handle_possible_state_change(event:InputEvent) -> void:
	EventBus.emit_signal("touch_debug_output",event.as_text())
	if event is InputEventMouseButton:
		if event.button_index != BUTTON_LEFT:
			return
		
		if !is_active() and event.is_pressed():
			if is_inside_panel_area(event):
				touch_id = 0
				state = input_state.MOUSE
				print_debug("Started dragging mouse ", debug_name)
		else:
			if is_active() and event.is_released():
				reset()
				print_debug("Ended draggin  mouse ", debug_name)
		
	
	if  event is InputEventScreenTouch:
		if !is_active() and event.is_pressed():
			if is_inside_panel_area(event):
				touch_id = event.index
				state = input_state.TOUCH
				print_debug("Started dragging touch", debug_name)
		else:
			if is_active() and event.is_released() and event.index == touch_id:
				reset()
				print_debug("Ended draggin touch", debug_name)

func handle_movement(event:InputEvent)->void:
	if event is InputEventScreenDrag:
		if state == input_state.TOUCH and event.index == touch_id:
			process_input(event)
	
	if event is InputEventMouseMotion:
		if state  == input_state.MOUSE:
			process_input(event)

func is_active() -> bool:
	return state != input_state.INACTIVE

func is_inside_panel_area(event:InputEvent)-> bool: 
	var length:float = (global_position - Vector2(get_global_event_position(event.position).x, get_global_event_position(event.position).y)).length_squared();
	return length < squaredHalfSizeLength

func process_input(event:InputEvent) -> void:
	calculateForce(get_global_event_position(event.position).x - global_position.x, get_global_event_position(event.position).y - global_position.y)
	updateBallPos()

func reset() -> void:
	state = input_state.INACTIVE
	touch_id=0
	calculateForce(0, 0)
	sendSignal2Listener()
	updateBallPos()

func updateBallPos()->void:
	ballPos.x = halfSize.x * currentForce.x #+ halfSize.x
	ballPos.y = halfSize.y * -currentForce.y #+ halfSize.y
	ball.position = Vector2(ballPos.x, ballPos.y)

func calculateForce(x:float, y:float) -> void:
	#get direction
	currentForce.x = (x - centerPoint.x)/halfSize.x
	currentForce.y = -(y - centerPoint.y)/halfSize.y
	if currentForce.length_squared()>1:
		currentForce=currentForce/currentForce.length()

	sendSignal2Listener()


#converts from event.position to global position
#https://www.reddit.com/r/godot/comments/gj4yev/convert_eventposition_mouse_to_local_position_in/
func get_global_event_position(event_position:Vector2)->Vector2:
	return get_canvas_transform().affine_inverse().xform(event_position)

func sendSignal2Listener()->void:
	map_anlog_to_joystick()

func map_anlog_to_joystick()->void:
#	print_debug(currentForce)
	Input.action_press("move_left",abs(currentForce.x)) if currentForce.x < -0.2  else Input.action_release("move_left")
	Input.action_press("move_right",abs(currentForce.x)) if currentForce.x > 0.2  else Input.action_release("move_right")
	Input.action_press("move_down",abs(currentForce.y)) if currentForce.y < -0.2  else Input.action_release("move_down")
	Input.action_press("move_up",abs(currentForce.y)) if currentForce.y > 0.2  else Input.action_release("move_up")

enum input_state {
	MOUSE,TOUCH,INACTIVE
}
