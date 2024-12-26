extends Control

## Simple scipt to test translations of cards. Just change the perk on this node and run.
##



export (PackedScene) var perk

onready var card = $"%PerkCard"
onready var languages = $"%Languages"


func _ready():
	card.perk = perk
	card.display_perk()
	
	for lang_btn in languages.get_children():
		lang_btn.connect("new_language_selected",self,"language_changed")
	


func language_changed(_new_language,_flag):
	card.display_perk()
