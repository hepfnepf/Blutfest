#tool
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

export (float) var hover_size = 1.3
export (float) var up_duration = 2
export (float) var down_duration = 2
var min_size:Vector2 = Vector2(0,0)

var is_hovered:bool = false
var weight:float = 0.0
var last_time:float = 0 #needed to make my own delta for the animation, since the delta in process does not work if the game is paused

func _ready()->void:
	display_perk()
	min_size = rect_min_size
	last_time = OS.get_ticks_msec()

func _process(delta: float) -> void:
	#makeing my own delta for the animation, since the delta in process does not work if the game is paused
	var new_time = OS.get_ticks_msec()
	delta = (new_time-last_time)/100

	if is_hovered:
		weight += delta/up_duration
	else:
		weight -= delta/down_duration

	weight=clamp(weight,0,1)
	rect_min_size=min_size.linear_interpolate(min_size*Vector2(hover_size,hover_size), weight)
	last_time = new_time

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
	is_hovered=true

func _on_Button_mouse_exited() -> void:
	is_hovered=false
