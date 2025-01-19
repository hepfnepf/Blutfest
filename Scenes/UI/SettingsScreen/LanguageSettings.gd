extends Tabs

onready var language_grid = $MarginContainer/GridContainer

func _ready() -> void:
	var locale:String = SaveManager.current_save_options["language"]
	if locale != "":
		TranslationServer.set_locale(SaveManager.current_save_options["language"])

	for child in language_grid.get_children():
		child.connect("new_language_selected",self,"_new_language_selected")

func _new_language_selected(flag)->void:
	#Actual language gets set in the flags code
	for child in language_grid.get_children():
		if child != flag:
			child.detoggle()

func toggle_on_current_language()->void:
	pass
