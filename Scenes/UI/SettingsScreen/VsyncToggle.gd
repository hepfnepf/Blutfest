extends CheckButton

func _ready() -> void:
	pressed=OS.vsync_enabled


func _on_VsyncToggle_toggled(button_pressed: bool) -> void:
	OS.vsync_enabled = button_pressed
