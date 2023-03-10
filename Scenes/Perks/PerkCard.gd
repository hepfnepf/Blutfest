tool
extends PanelContainer
class_name PerkCard

signal card_selected
var perk=null
var title:String = ""
var desc:String= ""

onready var nameLabel:Label = $"%NameLabel"
onready var rarityLabel:Label=$"%RarityLabel"
onready var icon:TextureRect=$"%Icon"
onready var descLabel:Label=$"%DescriptionLabel"

var min_size:Vector2 = Vector2(0,0)

func _ready()->void:
	display_perk()
	min_size = rect_min_size

func display_perk()->void:
	if perk == null:
		return
	var state:SceneState=perk.get_state()

	var prop_count:int = state.get_node_property_count(0)
	for i in range(prop_count):
		if state.get_node_property_name(0,i)=="title":
			title=state.get_node_property_value(0,i)
		if state.get_node_property_name(0,i)=="desc":
			desc=state.get_node_property_value(0,i)

	nameLabel.text = title
	descLabel.text= desc

func _on_Button_button_up()->void:
	emit_signal("card_selected",self)

func _on_Button_mouse_entered() -> void:
	rect_min_size *=1.3



func _on_Button_mouse_exited() -> void:
	print("left")
	rect_min_size = min_size
