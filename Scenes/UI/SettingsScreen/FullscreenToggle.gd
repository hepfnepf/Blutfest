extends CheckButton

func _ready() -> void:
	pressed = OS.window_fullscreen
	EventBus.connect("fullscreen_changed",self,"_on_fullscreen_changed")


func _on_FullscreenToggle_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed

func _on_fullscreen_changed():
	pressed = OS.window_fullscreen
