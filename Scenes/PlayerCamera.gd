extends Camera2D


var zoom_speed:float = 0.3

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			zoom -= Vector2(zoom_speed,zoom_speed)
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			zoom += Vector2(zoom_speed,zoom_speed)
		if zoom.x <= 0:#x=y, so i only have to check x
			zoom=Vector2(0,0)
