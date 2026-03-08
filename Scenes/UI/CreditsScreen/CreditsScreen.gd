extends Popup

func _ready():
	# show directly if only rendiring this scene for testing
	if get_path()=="/root/CreditsScreen":
		call_deferred("show")

func show()->void:
	popup()
	visible = true
	set_process_unhandled_input(true)
	hide_background_color()

func hide_background_color()->void:
	$ColorRect.color = Color(0,0,0,0)

func _unhandled_input(event)->void:
	if Input.is_action_just_pressed("Escape") or Input.is_action_just_pressed("ui_cancel"):
		if visible:
			accept_event()
			_on_ExitButton_pressed()
	

func _on_ExitButton_pressed()->void:
	visible = false
	set_process_unhandled_input(false)

#when clicking on a link
func _on_RichTextLabel_meta_clicked(meta) -> void:
	print_debug(meta)
	OS.shell_open(str(meta))
