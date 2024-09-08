tool
extends VBoxContainer

signal new_language_selected(new_language,flag)


export(Texture) var flag setget set_flag
export(String) var language_name = "" setget set_language
export(String) var language_id = ""

func _ready() -> void:
	assert(language_id!="","Langauge ID should not be empty!")


func set_flag(_flag:Texture)->void:
	$TextureButton.texture_normal = _flag
	flag = _flag

func set_language(new_langauge)->void:
	language_name=new_langauge
	$Label.text=new_langauge


func _on_TextureButton_toggled(button_pressed: bool) -> void:
	TranslationServer.set_locale(language_id)
	emit_signal("new_language_selected",language_id,self)

func detoggle()->void:
	$TextureButton.pressed=false
