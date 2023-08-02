extends CanvasLayer


onready var creditsScreen = $CreditsScreen
onready var settingsScreen = $SettingsScreen

func _ready() -> void:
	#Retrieve volume settings
	var sg = SaveManager.read_saveOptions()

	var sfx_db_value = linear2db(sg["sfx_volume"])
	var music_db_value = linear2db(sg["music_volume"])
	print_debug(music_db_value)

	var sfx_index= AudioServer.get_bus_index("SFX")
	var music_index= AudioServer.get_bus_index("Music")

	AudioServer.set_bus_volume_db(sfx_index, sfx_db_value)
	AudioServer.set_bus_volume_db(music_index, music_db_value)


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
