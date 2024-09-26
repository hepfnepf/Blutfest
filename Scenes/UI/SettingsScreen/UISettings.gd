extends Tabs

onready var blood_on_screen_toggle = $"%BloodOnScreenToggle"
onready var crosshair_dynamic_toggle = $"%CrosshairDynamicToggle"
onready var crosshair_cone_dynamic_toggle=$"%CrosshairDynamicConeToggle"
onready var crosshair_color_picker:ColorPickerButton =  $"%CrosshairColorPicker"
onready var crosshair_cone_color_picker = $"%CrosshairConeColorPicker"
onready var crosshair_size = $"%CrosshairSize"
onready var crosshair_cone_size:Slider=$"%CrosshairConeSize"
onready var crosshair_type =$MarginContainer/VBoxContainer/HBoxContainer/CrosshairTypeLabel
onready var crosshair_grid=$MarginContainer/VBoxContainer/CrosshairGrid
onready var cone_grid = $MarginContainer/VBoxContainer/CrosshairCone


var current_crosshair:int = Globals.CrosshairType.CROSSHAIR setget set_crosshair

func _ready() -> void:
	EventBus.connect("crosshair_color_change",self,"_on_crosshair_color_change")
	EventBus.connect("cone_crosshair_is_dynamic",self,"_on_cone_crosshair_dynamic_change")

func _on_CrosshairColorPicker_color_changed(color: Color) -> void:
	EventBus.emit_signal("crosshair_color_change",color)

func _on_BloodOnScreenToggle_toggled(button_pressed: bool) -> void:
	EventBus.emit_signal("blood_overlay_enabled",button_pressed)

func _on_CrosshairDynamicToggle_toggled(button_pressed: bool) -> void:
	EventBus.emit_signal("crosshair_is_dynamic",button_pressed)

func _on_CrosshairSize_value_changed(value: float) -> void:
	EventBus.emit_signal("crosshair_size_change",value)

func set_crosshair(crosshair:int)->void:
	current_crosshair=crosshair
	EventBus.emit_signal("crosshair_type_changed",crosshair)
	switch_crosshair_type(crosshair)


func switch_crosshair_type(c:int)->void:
	if c == Globals.CrosshairType.CROSSHAIR:
		crosshair_type.text=tr("CROSSHAIR")
		crosshair_grid.visible=true
		cone_grid.visible=false
	elif c == Globals.CrosshairType.CONE:
		crosshair_type.text=tr("CONE")
		crosshair_grid.visible=false
		cone_grid.visible=true

	else:
		crosshair_type.text=tr("BOTH")
		crosshair_grid.visible=true
		cone_grid.visible=true

func _on_CrosshairSwitchButtonLeft_pressed() -> void:
	if current_crosshair > 0:
		set_crosshair(current_crosshair-1)


func _on_CrosshairSwitchButtonRight_pressed() -> void:
	if current_crosshair < Globals.CrosshairType.size():
		set_crosshair(current_crosshair+1)

func _on_CrosshairDynamicConeToggle_toggled(button_pressed: bool) -> void:
	EventBus.emit_signal("cone_crosshair_is_dynamic",button_pressed)

func _on_CrosshairConeColorPicker_color_changed(color: Color) -> void:
	EventBus.emit_signal("crosshair_color_change",color)

func _on_CrosshairConeSize_value_changed(value: float) -> void:
	EventBus.emit_signal("cone_crosshair_size_change",value)

func _on_crosshair_color_change(new_color:Color)->void:
	crosshair_color_picker.color=new_color
	crosshair_cone_color_picker.color=new_color

func _on_cone_crosshair_dynamic_change(is_dynamic:bool)->void:
	crosshair_cone_size.editable = !is_dynamic
