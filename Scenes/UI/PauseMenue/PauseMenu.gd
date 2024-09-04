extends Control
class_name PauseMenu

onready var credits = $CreditsScreen
onready var options = $SettingsScreen
onready var sfx_slider = $CenterContainer/VBoxContainer/HBoxContainer/SFXSlider
onready var music_slider = $CenterContainer/VBoxContainer/HBoxContainer/MusicSlider

var debug_info = null

var blocked := false

func _ready() -> void:
	options.connect("changed_sound",self,"_on_reset_sound")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("Escape") and !blocked:
		switch_state()
	if Input.is_action_just_pressed("show_debug_info") and visible:
		if is_instance_valid(debug_info):
			debug_info.set_alive(!debug_info.alive)

func set_debug_info(_debug_info)->void:
	debug_info = _debug_info

func switch_state():
	if !get_parent().card_holder.visible:
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
	var sg = SaveManager.get_options_save()
	sg["sfx_volume"] = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))#sfx_slider.slider.value
	sg["music_volume"] = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sg["sfx_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	sg["music_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	SaveManager.set_options_save(sg)

func _on_ReturnButton_pressed():
	switch_state()


func _on_OptionsButton_pressed():
	if is_instance_valid(options):
		options.show()


func _on_CreditsButton_pressed():
	if is_instance_valid(credits):
		credits.visible = true


func _on_ExitButton_pressed():

	#Save new volume setting if changed in linear between 0 and 1
	if sfx_slider.has_chagend or music_slider.has_chagend:
		save_volume()

	#Back tu main menu
	get_tree().paused = false
	TimeManager.set_time_scale(1.0)
	get_tree().change_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")

func _on_Player_Death(): # gets connected in GUI
	blocked = true
	print_debug("died")

func _on_reset_sound():
	var sg = SaveManager.get_options_save()

	sfx_slider.value_change_code(sg["sfx_volume"])
	music_slider.value_change_code(sg["music_volume"])

func _on_Restart_pressed():
	#Save new volume setting if changed in linear between 0 and 1
	if sfx_slider.has_chagend or music_slider.has_chagend:
		save_volume()

	switch_state()
	Globals.game.restart()
