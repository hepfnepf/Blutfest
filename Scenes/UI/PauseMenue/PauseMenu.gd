extends Control
class_name PauseMenu

onready var credits = $CreditsScreen
onready var options = $SettingsScreen
onready var sfx_slider = $CenterContainer/VBoxContainer/HBoxContainer/SFXSlider
onready var music_slider = $CenterContainer/VBoxContainer/HBoxContainer/MusicSlider

var blocked := false


func _input(event):
	if Input.is_action_just_pressed("Escape") and !blocked:
		switch_state()
		# Pause game


func switch_state():
	get_tree().paused = !get_tree().paused
	visible = !visible
	if credits.visible:
		credits.visible = false

	#Change Cursor
	if Globals.cursor_manager.cursor == Cursor.CURSOR_TYPE.CROSSHAIR:
		Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	else:
		Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR)

	#Save new volume setting in linear between 0 and 1
	if sfx_slider.has_chagend or music_slider.has_chagend:
		save_volume()

func save_volume() -> void:
	var sg = SaveManager.read_saveOptions()
	sg["sfx_volume"] = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))#sfx_slider.slider.value
	sg["music_volume"] = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	SaveManager.save_options(sg)

func _on_ReturnButton_pressed():
	switch_state()


func _on_OptionsButton_pressed():
	if is_instance_valid(options):
		options.show()
	#pass # Replace with function body.


func _on_CreditsButton_pressed():
	if is_instance_valid(credits):
		credits.visible = true


func _on_ExitButton_pressed():

	#Save new volume setting if changed in linear between 0 and 1
	if sfx_slider.has_chagend or music_slider.has_chagend:
		save_volume()

	#Quit game
	get_tree().quit()

func _on_Player_Death(): # gets connected in GUI
	blocked = true
	print_debug("died")


func _on_Restart_pressed():
	#Save new volume setting if changed in linear between 0 and 1
	if sfx_slider.has_chagend or music_slider.has_chagend:
		save_volume()

	switch_state()
	get_tree().reload_current_scene()
