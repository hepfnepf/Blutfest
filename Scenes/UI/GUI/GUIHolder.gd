extends Node

onready var gui = null

func _ready()->void:
	if Globals.andoid:
		gui = $GUIAndoid
		$GUI.queue_free()
		gui.visible=true
	else:
		gui = $GUI
		$GUIAndoid.queue_free()
