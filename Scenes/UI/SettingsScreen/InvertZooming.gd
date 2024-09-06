extends CheckBox

func _ready() -> void:
	EventBus.connect("zooming_inverted",self,"_on_zooming_inverted")
	pressed = SaveManager.get_options_save()["zooming_inverted"]

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	EventBus.emit_signal("zooming_inverted",button_pressed)

func _on_zooming_inverted(zooming_inverted:bool)->void:
	pressed = zooming_inverted
