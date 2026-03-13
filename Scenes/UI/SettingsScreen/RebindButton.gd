extends Button

export (String) var rebind_action

var waiting_for_input:bool=false

enum INPUT_REBIND_MODES {
	KEYBOARD,
	CONTROLLER
}

var mode:int = INPUT_REBIND_MODES.KEYBOARD setget set_mode

func _ready() -> void:
	update_text()
	EventBus.connect("settings_reset",self,"update_text")

func set_mode(_mode:int)->void:
	mode = _mode
	update_text()

func set_mode_by_string(_mode:String)->void:
	if _mode == "CONTROLLER":
		set_mode(INPUT_REBIND_MODES.CONTROLLER)
	elif _mode == "KEYBOARD":
		set_mode(INPUT_REBIND_MODES.KEYBOARD)
	else:
		printerr("Wrong input mode passed.")

func update_text()->void:
	var _text:String = ""
	for map_event in InputMap.get_action_list(rebind_action):
			if map_event is InputEventKey and mode==INPUT_REBIND_MODES.KEYBOARD:
				_text = OS.get_scancode_string(map_event.scancode)
			elif  map_event is InputEventJoypadButton and mode==INPUT_REBIND_MODES.CONTROLLER:
				_text =  Input.get_joy_button_string(map_event.button_index)
	text = _text

func _on_RebindButton_button_up() -> void:
	waiting_for_input=true

func _input(event: InputEvent) -> void:
	if waiting_for_input:
		if event is InputEventKey and mode==INPUT_REBIND_MODES.KEYBOARD:
			for map_event in InputMap.get_action_list(rebind_action):
				if map_event is InputEventKey:
					_bind_input(rebind_action,map_event,event)
		elif event is InputEventJoypadButton and mode==INPUT_REBIND_MODES.CONTROLLER:
			for map_event in InputMap.get_action_list(rebind_action):
				if map_event is InputEventJoypadButton:
					_bind_input(rebind_action,map_event,event)

func _bind_input(action:String,current_event:InputEvent,new_event:InputEvent)->void:
	InputMap.action_erase_event(action,current_event)
	InputMap.action_add_event(action,new_event)
	waiting_for_input = false
	update_text()
	accept_event()
