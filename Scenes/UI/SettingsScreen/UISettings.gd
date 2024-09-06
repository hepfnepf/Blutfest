extends Tabs

onready var blood_on_screen_toggle = $"%BloodOnScreenToggle"
onready var crosshair_dynamic_toggle = $"%CrosshairDynamicToggle"
onready var crosshair_color_picker:ColorPickerButton =  $"%CrosshairColorPicker"
onready var crosshair_size = $"%CrosshairSize"


func _on_CrosshairColorPicker_color_changed(color: Color) -> void:
	EventBus.emit_signal("crosshair_color_change",color)


func _on_BloodOnScreenToggle_toggled(button_pressed: bool) -> void:
	EventBus.emit_signal("blood_overlay_enabled",button_pressed)


func _on_CrosshairDynamicToggle_toggled(button_pressed: bool) -> void:
	EventBus.emit_signal("crosshair_is_dynamic",button_pressed)



func _on_CrosshairSize_value_changed(value: float) -> void:
	EventBus.emit_signal("crosshair_size_change",value)
