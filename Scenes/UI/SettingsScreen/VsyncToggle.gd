extends CheckButton

func _ready() -> void:
	pressed=OS.vsync_enabled
	EventBus.connect("vsync_changed",self,"_on_vsync_changed")


func _on_VsyncToggle_toggled(button_pressed: bool) -> void:
	OS.vsync_enabled = button_pressed

func _on_vsync_changed():
	pressed=OS.vsync_enabled
