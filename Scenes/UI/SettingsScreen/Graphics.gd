extends "res://Scenes/UI/SettingsScreen/ExtendedTabs.gd"


func _ready():
	if Globals.android:
		queue_free()
