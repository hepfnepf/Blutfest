extends Tabs

onready var zoom_inverted_toggle_button = $"%CheckBox"

func get_key_binding_dict()->Dictionary:
	var bindings = {}
	var actions = InputMap.get_actions()
	for action in actions:
		bindings[action] = SaveManager.serialize_action(action)

	return bindings




