extends "res://Scenes/UI/SettingsScreen/ExtendedTabs.gd"

onready var zoom_inverted_toggle_button = $"%CheckBox"

func _ready():
	if Globals.android:
		queue_free()
