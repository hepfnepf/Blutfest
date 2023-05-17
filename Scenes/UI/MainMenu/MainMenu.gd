extends CanvasLayer


onready var creditsScreen = $CreditsScreen
onready var settingsScreen = $SettingsScreen

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_OptionsButton_pressed() -> void:
	settingsScreen.visible = true
	settingsScreen.hide_background_color()


func _on_CreditsButton_pressed() -> void:
	creditsScreen.visible = true
	creditsScreen.hide_background_color()
