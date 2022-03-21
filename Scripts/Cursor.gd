extends Node
class_name Cursor

enum CURSOR_TYPE{DEFAULT,CROSSHAIR}

"""
Sets the Cursor to one of modes defined in CURSOR_TYPE.
"""

var crosshair = null
var cursor=CURSOR_TYPE.DEFAULT

func set_crosshair(cross)->void:
	crosshair = cross

func set_cursor(cursor_type:int) -> void:
	if cursor_type == CURSOR_TYPE.CROSSHAIR:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		cursor=CURSOR_TYPE.CROSSHAIR
		if crosshair != null:
			crosshair.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursor=CURSOR_TYPE.DEFAULT
		if crosshair != null:
			crosshair.visible = false
