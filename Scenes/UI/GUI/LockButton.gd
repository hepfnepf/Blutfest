extends  "res://Scenes/UI/GUI/TouchableButton.gd"


# This Button is for the android GUI so that players can trigger the lock in the UI
# Toproduce as little entanglement as possible, it simply send the key for you
# This way, the Event can continue to be handled by the player with the regular input handler
# and the player script does not have to care about running on android or pc
# If instead I would use an additional signal i would have to not forget to handle it too
# everywhere I want to handle the input event, which is basically like a signal anyways
# Thoug I admit, it may be nicer than having to use  call_deferred("resetLockKey") so I may change it later


export(Color) var locked_color = Color(1,1,1,0)

func switch_to_lockstate(new_state:bool)->void:
	if new_state:
		modulate = locked_color;
	else:
		modulate = Color(1,1,1,1)
