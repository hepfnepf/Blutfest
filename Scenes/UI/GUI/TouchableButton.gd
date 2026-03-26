extends Button


# This Button exists to be used with touchscreens
# Nomal Buttons dont work, when used with multitouch. If somethins else is being pressed e.g. the joypad,
# regular buttons wont work
# But this one does!

## Action to be performed when pressed
export(String)var action=""

func _on_Button_pressed()->void:
	var actionEvent:InputEventAction = InputEventAction.new()
	actionEvent.action = action
	actionEvent.pressed = true
	Input.parse_input_event(actionEvent)
	call_deferred("resetActionKey")

func resetActionKey()->void:
	var actionEvent:InputEventAction = InputEventAction.new()
	actionEvent.action = action
	actionEvent.pressed = false
	Input.parse_input_event(actionEvent)

func _input(event:InputEvent)->void:
	if event is InputEventScreenTouch and event.is_released():
		if is_inside_button(event.position):
			_on_Button_pressed()

# Requires recent position not global position
func is_inside_button(position:Vector2)->bool:
	var pos:Vector2 = get_global_event_position(position)
	if pos.x > rect_global_position.x and pos.x  <  rect_global_position.x+rect_size.x:
		if pos.y > rect_global_position.y and pos.y  <  rect_global_position.y+rect_size.y:
			return true	
	return false
	

func get_global_event_position(event_position:Vector2)->Vector2:
	return get_canvas_transform().affine_inverse().xform(event_position)
