tool
extends VBoxContainer

signal new_language_selected(flag)


export(Texture) var flag setget set_flag
export(String) var language_name = "" setget set_language
export(String) var language_name_translated = "" setget set_translated_language
export(String) var language_id = ""


onready var own_name = $LabelOwnName
onready var translated_name = $LabelTranslatedName

func _ready() -> void:
	assert(language_id!="","Langauge ID should not be empty!")


func set_flag(_flag:Texture)->void:
	$TextureButton.texture_normal = _flag
	flag = _flag

func set_language(new_langauge)->void:
	language_name=new_langauge
	$LabelOwnName.text=new_langauge

func set_translated_language(new_langauge)->void:
	language_name_translated = new_langauge
	$LabelTranslatedName.text = new_langauge

func _on_TextureButton_toggled(button_pressed: bool) -> void:
	TranslationServer.set_locale(language_id)
	emit_signal("new_language_selected",self)

func detoggle()->void:
	$TextureButton.pressed=false
