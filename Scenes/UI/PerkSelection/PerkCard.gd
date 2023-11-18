#tool
extends PanelContainer
class_name PerkCard

signal card_selected
var perk:PackedScene=null
var title:String = ""
var desc:String= ""

onready var nameLabel:Label = $"%NameLabel"
onready var rarityLabel:Label=$"%RarityLabel"
onready var icon:TextureRect=$"%Icon"
onready var descLabel:Label=$"%DescriptionLabel"

export (float) var hover_size = 1.3
export (float) var up_speed = 3.0
export (float) var down_speed = 5.0
var min_size:Vector2 = Vector2(0,0)

var rarity:int = 0#gets set by gui when adding cards to cardholder
var is_hovered:bool = false
var weight:float = 0.0
var disabled:bool = false

## rarity colors
var color_common:Color = Color.gray
var color_normal:Color = Color(0.49,0.09,0.09,1)
var color_rare:Color = Color.webgreen
var color_legendary:Color = Color.darkmagenta

func _ready()->void:
	display_perk()
	min_size = rect_min_size

func _process(delta: float) -> void:
	if disabled:
		return
	if is_hovered:
		weight += delta*up_speed
	else:
		weight -= delta*down_speed

	weight=clamp(weight,0,1)
	rect_min_size=min_size.linear_interpolate(min_size*Vector2(hover_size,hover_size), weight)


func display_perk()->void:
	if perk == null:
		return

	var _perk:Perk=perk.instance()
	title = _perk.get_title()
	desc = _perk.get_desc()

	nameLabel.text = title
	descLabel.text= desc
	apply_rarity()
	rarityLabel.text = get_rarity_string(rarity)

	_perk.queue_free()


func get_rarity_string(rarity:int)->String:
	#gets set by GUI, which gets the cards and rarity from the perk manager
	if rarity == Globals.Rarity.COMMON:
		return tr("RARITY_COMMON")
	if rarity == Globals.Rarity.NORMAL:
		return tr("RARITY_NORMAL")
	if rarity == Globals.Rarity.RARE:
		return tr("RARITY_RARE")
	if rarity == Globals.Rarity.LEGENDARY:
		return tr("RARITY_LEGENDARY")
	else:
		printerr("Rarity is no known level")
		return "Error"

func apply_rarity() -> void:
	rarityLabel.text = get_rarity_string(rarity)
	if rarity == Globals.Rarity.COMMON:
		_apply_rarity_color(color_common)
	elif rarity == Globals.Rarity.NORMAL:
		_apply_rarity_color(color_normal)
	elif rarity == Globals.Rarity.RARE:
		_apply_rarity_color(color_rare)
	else:
		_apply_rarity_color(color_legendary)

func _apply_rarity_color(color:Color) -> void:
	var stylebox:StyleBoxFlat =  theme.get_stylebox("panel","PanelContainer").duplicate()#StyleBoxFlat.new()
	add_stylebox_override("panel",stylebox)
	stylebox.border_color=color
	nameLabel.add_color_override("font_color",color)
	rarityLabel.add_color_override("font_color",color)
	descLabel.add_color_override("font_color",color)


func _on_Button_button_up()->void:
	if disabled:
		return
	emit_signal("card_selected",self)

func _on_Button_mouse_entered() -> void:
	is_hovered=true

func _on_Button_mouse_exited() -> void:
	is_hovered=false
