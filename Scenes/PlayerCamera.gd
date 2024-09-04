extends Camera2D


var zoom_speed:float = 0.3

func _input(event)->void:
	#The reason for this seemingly unneccessary _zoom variable in between, is that setting zoom=Vector(0,0) triggers an error, so we cant directly add/substract from the value
	#but have to use an intermediate value to make sure we do not set zoom itself to 0 ever
	var _zoom:Vector2 = zoom
	if event is InputEventMouseButton and OS.is_debug_build():
		if event.button_index == BUTTON_WHEEL_UP and event.pressed:
			_zoom -= Vector2(zoom_speed,zoom_speed)
		elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
			_zoom += Vector2(zoom_speed,zoom_speed)
		if _zoom.x <= 0:#x=y, so i only have to check x
			_zoom=Vector2(0.3,0.3)
		zoom=_zoom
