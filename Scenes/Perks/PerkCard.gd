tool
extends PanelContainer

export (PackedScene)var perk=null

onready var nameLabel:Label = $"%NameLabel"
onready var rarityLabel:Label=$"%RarityLabel"
onready var icon:TextureRect=$"%Icon"
onready var descLabel:Label=$"%DescriptionLabel"

func _ready():
	display_perk()

func display_perk():
	if perk == null:
		return
	var state:SceneState=perk.get_state()
	var title:String = ""
	var desc:String= ""
	
	var prop_count:int = state.get_node_property_count(0)
	for i in range(prop_count):
		if state.get_node_property_name(0,i)=="title":
			title=state.get_node_property_value(0,i)
		if state.get_node_property_name(0,i)=="desc":
			desc=state.get_node_property_value(0,i)
	
	nameLabel.text = title
	descLabel.text= desc
	
	
