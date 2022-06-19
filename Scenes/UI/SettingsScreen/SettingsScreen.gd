extends MarginContainer

onready var but_resset_highscore = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/ResetHighscore
onready var hs_reset_announcement = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/HighscoreResetAnnouncement
onready var hs_reset_announcement_time = $ColorRect/MarginContainer/VBoxContainer/TabContainer/Game/MarginContainer/VBoxContainer/HighscoreResetAnnouncement/Timer



func _on_ExitButton_pressed():
	visible = false


func _on_ResetHighscore_pressed():
	var save_dict = SaveManager.read_savegame()
	save_dict["highscore"] = 0
	save_dict["best_time"] = 0
	SaveManager.save(save_dict)

	hs_reset_announcement.show()
	hs_reset_announcement_time.start()



func _on_Timer_timeout():
	hs_reset_announcement.hide()
