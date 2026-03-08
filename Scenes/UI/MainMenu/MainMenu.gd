extends CanvasLayer


export(NodePath) var initial_focus_object

onready var creditsScreen = $CreditsScreen
onready var settingsScreen = $SettingsScreen

func _ready():
	get_node(initial_focus_object).grab_focus()

func _on_PlayButton_pressed() -> void:
	get_tree().change_scene("res://Scenes/Game.tscn")


func _on_OptionsButton_pressed() -> void:
	settingsScreen.show()


func _on_CreditsButton_pressed() -> void:
	creditsScreen.show()

func _on_ExitButton_pressed() -> void:
	get_tree().quit()
