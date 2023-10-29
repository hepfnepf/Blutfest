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

var rarity:int = 0
var is_hovered:bool = false
var weight:float = 0.0
var disabled:bool = false

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
	rarityLabel.text = get_rarity_string(rarity)

	_perk.queue_free()


func get_rarity_string(rarity:int)->String:
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

func _on_Button_button_up()->void:
	if disabled:
		return
	emit_signal("card_selected",self)

func _on_Button_mouse_entered() -> void:
	is_hovered=true

func _on_Button_mouse_exited() -> void:
	is_hovered=false
