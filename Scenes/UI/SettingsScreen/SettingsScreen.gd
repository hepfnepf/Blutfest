extends MarginContainer

signal changed_sound

onready var but_resset_highscore = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/ResetHighscore
onready var hs_reset_announcement = $"%HighscoreResetAnnouncement"
onready var hs_reset_announcement_time = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/HighscoreResetAnnouncement/Timer
onready var op_reset_announcement = $"%OptionsResetAnnouncement"
onready var op_reset_announcement_timer = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/OptionsResetAnnouncement/Timer



func _on_ExitButton_pressed():
	visible = false


func _on_ResetHighscore_pressed():
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

func _on_Timer_timeout():
	hs_reset_announcement.hide()
	op_reset_announcement.hide()



