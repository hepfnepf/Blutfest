extends Tabs

onready var zoom_inverted_toggle_button = $"%CheckBox"

func _ready():
	if Globals.android:
		queue_free()

# The SettingsScreen calls this method to store the current keybindings in the save game file, when exiting the screen
#func get_key_binding_dict()->Dictionary:
#	var bindings = {}
#	var actions = InputMap.get_actions()
#	for action in actions:
#		bindings[action] = SaveManager.serialize_action(action)
#
#	return bindings




