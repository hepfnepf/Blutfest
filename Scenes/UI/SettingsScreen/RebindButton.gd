extends Button

export (String) var rebind_action

var waiting_for_input:bool=false


func _ready() -> void:
	update_text()

func update_text()->void:
	var _text:String = ""
	for map_event in InputMap.get_action_list(rebind_action):
			if map_event is InputEventKey:
				_text = OS.get_scancode_string(map_event.scancode)
	text = _text

func _on_RebindButton_button_up() -> void:
	waiting_for_input=true


func _input(event: InputEvent) -> void:
	if event is InputEventKey and waiting_for_input:
		for map_event in InputMap.get_action_list(rebind_action):
			if map_event is InputEventKey:
				InputMap.action_erase_event(rebind_action,map_event)
		InputMap.action_add_event(rebind_action,event)
		waiting_for_input = false
		update_text()
