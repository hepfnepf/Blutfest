extends Popup

onready var web_warning:Label = $"%WebWarning"
onready var movement_label:Label = $"%Movement"
onready var aiming_label_keyboard:Label = $"%Shooting"
onready var shooting_controller:Label = $"%ShootingController"
onready var controller_move_aim_label:Label = $"%ControllerMoveShoot"
onready var locking_label:Label = $"%Locking"
onready var reloading_label:Label = $"%Reloading"
onready var weapon_info_label:Label =  $"%WeaponInfo"
onready var help_label:Label = $"%Help"

var toggle_input_mode:int = Globals.InputMode.KEYBOARD_MOUSE

func _ready() -> void:
	if OS.get_name()=="HTML5":
		web_warning.visible=true

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("help") and visible:
		hide()

	elif Input.is_action_just_pressed("help") and !visible and !get_tree().paused:#game should not be in main menu or card selection
		Globals.switch_input_mode_by_event(_event)#sets the input mode to controller/keyboard so that the correct binigs are shown
		popup()


func update_key_bindings()->void:
	movement_label.text = "%s, %s, %s, %s - %s"%[get_key_binding("move_up"),get_key_binding("move_left"),  get_key_binding("move_down"), get_key_binding("move_right"),tr("HELP_MOVEMENT")]
	shooting_controller.text = "%s - %s"%[get_key_binding("fire"),tr("HELP_SHOOTING_CONTROLLER")]
	reloading_label.text = "%s - %s"%[get_key_binding("reload"),tr("HELP_RELOAD")]
	locking_label.text = "%s - %s"%[get_key_binding("lock_weapon"),tr("HELP_LOCKING")]
	weapon_info_label.text = "%s - %s"%[get_key_binding("toggle_weapon_info"),tr("HELP_WEAPON_INFO")]
	help_label.text = "%s - %s"%[get_key_binding("help"),tr("HELP_HELP")]

func get_key_binding(action:String)->String:
	var key_string:=""
	for map_event in InputMap.get_action_list(action):
			if map_event is InputEventKey and Globals.last_input_mode==Globals.InputMode.KEYBOARD_MOUSE:
				key_string = OS.get_scancode_string(map_event.scancode)
			elif map_event is InputEventJoypadButton and Globals.last_input_mode==Globals.InputMode.CONTROLLER:
				key_string =  Input.get_joy_button_string(map_event.button_index)
	return key_string

func adjust_base_on_input_mode()->void:
	if Globals.last_input_mode==Globals.InputMode.CONTROLLER:
		movement_label.hide()
		aiming_label_keyboard.hide()
		controller_move_aim_label.show()
		shooting_controller.show()

func reset_input_mode_adjustment()->void:
	movement_label.show()
	aiming_label_keyboard.show()
	controller_move_aim_label.hide()
	shooting_controller.hide()

func _on_InstructionsPopup_about_to_show() -> void:
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	update_key_bindings()
	get_tree().paused = true
	adjust_base_on_input_mode()

func _on_InstructionsPopup_popup_hide() -> void:
	get_tree().paused = false
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR)
	Globals.first_start=false
	reset_input_mode_adjustment()
