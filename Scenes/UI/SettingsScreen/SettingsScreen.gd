extends MarginContainer

signal changed_sound

onready var hs_reset_announcement = $"%HighscoreResetAnnouncement"
onready var hs_reset_announcement_time = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/HighscoreResetAnnouncement/Timer
onready var op_reset_announcement = $"%OptionsResetAnnouncement"
onready var op_reset_announcement_timer = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/OptionsResetAnnouncement/Timer


onready var sfx_slider = $"%SFXSlider"
onready var music_slider = $"%MusicSlider"

func _on_ExitButton_pressed()->void:
	visible = false
	store_settings()



func _on_ResetHighscore_pressed()->void:
	var save_dict = SaveManager.get_game_save()
	save_dict["highscore"] = 0
	save_dict["best_time"] = 0
	SaveManager.set_game_save(save_dict)

	hs_reset_announcement.show()
	hs_reset_announcement_time.start()

func _on_ResetOptions_pressed() -> void:
	SaveManager.create_empty_save_options_file()


	op_reset_announcement.show()
	op_reset_announcement_timer.start()

	emit_signal("changed_sound")

func hide_background_color():
	$ColorRect.color = Color(0,0,0,0)

func _on_Timer_timeout()->void:
	hs_reset_announcement.hide()
	op_reset_announcement.hide()


func _on_VsyncToggle_toggled(button_pressed:bool)->void:
	OS.vsync_enabled = button_pressed

"""
Begin of saving funtions
"""
func store_settings()->void:
	var sg = SaveManager.get_options_save()

	sg["sfx_volume"] = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	sg["music_volume"] = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sg["sfx_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	sg["music_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))

	sg["fullscreen_enabled"] = OS.window_fullscreen
	sg["vsync_enabled"]= OS.vsync_enabled

	sg["zooming_inverted"]=Globals.zooming_inverted

	SaveManager.set_options_save(sg)
