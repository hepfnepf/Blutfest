extends CanvasLayer


onready var creditsScreen = $CreditsScreen
onready var settingsScreen = $SettingsScreen

func _ready() -> void:
	#Retrieve volume settings
	var sg = SaveManager.get_options_save()

	var sfx_index= AudioServer.get_bus_index("SFX")
	var music_index= AudioServer.get_bus_index("Music")

	var sfx_db_value = linear2db(sg["sfx_volume"])
	var music_db_value = linear2db(sg["music_volume"])

	var sfx_muted = sg["sfx_disabled"]
	var music_muted = sg["music_disabled"]


	AudioServer.set_bus_volume_db(sfx_index, sfx_db_value)
	AudioServer.set_bus_volume_db(music_index, music_db_value)
	AudioServer.set_bus_mute(sfx_index,sfx_muted)
	AudioServer.set_bus_mute(music_index,music_muted)



func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_OptionsButton_pressed() -> void:
	settingsScreen.visible = true
	settingsScreen.hide_background_color()


func _on_CreditsButton_pressed() -> void:
	creditsScreen.visible = true
	creditsScreen.hide_background_color()


func _on_ExitButton_pressed() -> void:
	get_tree().quit()
