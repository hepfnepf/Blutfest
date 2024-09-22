extends Tabs

onready var blood_on_screen_toggle = $"%BloodOnScreenToggle"
onready var crosshair_dynamic_toggle = $"%CrosshairDynamicToggle"
onready var crosshair_color_picker:ColorPickerButton =  $"%CrosshairColorPicker"
onready var crosshair_size = $"%CrosshairSize"
onready var crosshair_type =$MarginContainer/VBoxContainer/HBoxContainer/CrosshairTypeLabel


var current_crosshair:int = Globals.CrosshairType.CROSSHAIR setget set_crosshair

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
	set_crosshair_type_label(crosshair)

func set_crosshair_type_label(c:int)->void:
	if c == Globals.CrosshairType.CROSSHAIR:
		crosshair_type.text=tr("CROSSHAIR")
	elif c == Globals.CrosshairType.CONE:
		crosshair_type.text=tr("CONE")
	else:
		crosshair_type.text=tr("BOTH")

func _on_CrosshairSwitchButtonLeft_pressed() -> void:
	if current_crosshair > 0:
		set_crosshair(current_crosshair-1)


func _on_CrosshairSwitchButtonRight_pressed() -> void:
	if current_crosshair < Globals.CrosshairType.size():
		set_crosshair(current_crosshair+1)
