extends MarginContainer


onready var focus_control:ControllerFocusManagement = $ControllerFocusManagement

func show()->void:
	visible = true
	set_process_unhandled_input(true)
	hide_background_color()
	focus_control.receive_focus()

func hide_background_color()->void:
	$ColorRect.color = Color(0,0,0,0)

func _unhandled_input(event)->void:
	if Input.is_action_just_pressed("Escape") or Input.is_action_just_pressed("ui_cancel"):
		if visible:
			_on_ExitButton_pressed()
	

func _on_ExitButton_pressed()->void:
	visible = false
	set_process_unhandled_input(false)
	focus_control.return_focus()

#when clicking on a link
func _on_RichTextLabel_meta_clicked(meta) -> void:
	print_debug(meta)
	OS.shell_open(str(meta))
