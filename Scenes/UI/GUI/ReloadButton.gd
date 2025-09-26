extends  "res://Scenes/UI/GUI/TouchableButton.gd"


# This Button is for the android GUI so that players can trigger the reload in the UI
# Toproduce as little entanglement as possible, it simply send the key for you
# This way, the Event can continue to be handled by the player with the regular input handler
# and the player script does not have to care about running on android or pc
# If instead I would use an additional signal i would have to not forget to handle it too
# everywhere I want to handle the input event, which is basically like a signal anyways
# Thoug I admit, it may be nicer than having to use  call_deferred("reload") so I may change it later

func _on_Button_pressed()->void:
	var reloadEvent:InputEventAction = InputEventAction.new()
	reloadEvent.action = "reload"
	reloadEvent.pressed = true
	Input.parse_input_event(reloadEvent)
	call_deferred("resetReloadKey")

func resetReloadKey() -> void:
	var reloadEvent:InputEventAction = InputEventAction.new()
	reloadEvent.action = "reload"
	reloadEvent.pressed = false
	Input.parse_input_event(reloadEvent)
