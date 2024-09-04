extends MarginContainer

signal changed_sound

onready var but_reset_highscore = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/ResetHighscore
onready var hs_reset_announcement = $"%HighscoreResetAnnouncement"
onready var hs_reset_announcement_time = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/HighscoreResetAnnouncement/Timer
onready var op_reset_announcement = $"%OptionsResetAnnouncement"
onready var op_reset_announcement_timer = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/OptionsResetAnnouncement/Timer


onready var sfx_slider = $"%SFXSlider"
onready var music_slider = $"%MusicSlider"

func _on_ExitButton_pressed()->void:
	visible = false
	#Save new volume setting in linear between 0 and 1
	store_changes()



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


"""
Begin of saving funtions
"""


func store_changes()->void:
	if sfx_slider.has_chagend or music_slider.has_chagend:
		save_volume()

func save_volume() -> void:
	var sg = SaveManager.get_options_save()
	sg["sfx_volume"] = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	sg["music_volume"] = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sg["sfx_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	sg["music_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))
	SaveManager.set_options_save(sg)
