extends Popup


onready var movement_label = $"%Movement"
onready var locking_label = $"%Locking"
onready var reloading_label = $"%Reloading"
onready var weapon_info_label =  $"%WeaponInfo"
onready var help_label = $"%Help"


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("help") and visible:
		hide()

	elif Input.is_action_just_pressed("help") and !visible and !get_tree().paused:#game should not be in main menu or card selection
		popup()


func update_key_bindings()->void:
	movement_label.text = "%s, %s, %s, %s - %s"%[get_key_binding("move_up"),get_key_binding("move_left"),  get_key_binding("move_down"), get_key_binding("move_right"),tr("HELP_MOVEMENT")]
	reloading_label.text = "%s - %s"%[get_key_binding("reload"),tr("HELP_RELOAD")]
	locking_label.text = "%s - %s"%[get_key_binding("lock_weapon"),tr("HELP_LOCKING")]
	weapon_info_label.text = "%s - %s"%[get_key_binding("toggle_weapon_info"),tr("HELP_WEAPON_INFO")]
	help_label.text = "%s - %s"%[get_key_binding("help"),tr("HELP_HELP")]

func get_key_binding(action:String)->String:
	var key_string:=""
	for map_event in InputMap.get_action_list(action):
			if map_event is InputEventKey:
				key_string = OS.get_scancode_string(map_event.scancode)
	return key_string

func _on_InstructionsPopup_about_to_show() -> void:
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	update_key_bindings()
	get_tree().paused = true


func _on_InstructionsPopup_popup_hide() -> void:
	get_tree().paused = false
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR)
	Globals.first_start=false
