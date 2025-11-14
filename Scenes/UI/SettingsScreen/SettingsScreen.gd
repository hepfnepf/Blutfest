extends MarginContainer


onready var game_tab = $"%Game"
onready var ui_tab = $"%UI"
onready var controls_tab = $"%Controls"
onready var sound_tab = $"%Sound"
onready var language_tab = $"%Language"
onready var main_focus_manager = $ControllerFocusManagement
onready var tab_container:TabContainer=$"%TabContainer"

func _ready() -> void:
	load_settings()
	EventBus.connect("settings_reset",self,"load_settings")


func _on_ExitButton_pressed()->void:
	visible = false
	store_settings()
	main_focus_manager.return_focus()
	 #the individual tabs grap the focus manual via grab_focus() on a button when shown
	# Otherwise this would cause issues with the focus controller, because the exit-button 
	# would remove the current tab but not the setting menu

func hide_background_color():
	$ColorRect.color = Color(0,0,0,0)

func show()->void:
	visible=true
	main_focus_manager.receive_focus()

func _unhandled_input(event):
	if visible:
		if Input.is_action_just_pressed("ui_switch_tab_next"):
			tab_container.current_tab= clamp(tab_container.current_tab+1,0,tab_container.get_tab_count()-1)
		elif Input.is_action_just_pressed("ui_switch_tab_previous"):
			tab_container.current_tab= clamp(tab_container.current_tab-1,0,tab_container.get_tab_count()-1)

func load_settings()->void:
	var sg = SaveManager.get_options_save()

	ui_tab.blood_on_screen_toggle.pressed = sg["blood_overlay_enabled"]
	ui_tab.crosshair_dynamic_toggle.pressed=sg["crosshair_is_dynamic"]
	ui_tab.crosshair_color_picker.color= Color(sg["crosshair_color"])
	ui_tab.crosshair_size.value= sg["crosshair_size"]
	ui_tab.current_crosshair=sg["crosshair_type"]
	ui_tab.crosshair_cone_dynamic_toggle.pressed=sg["cone_crosshair_is_dynamic"]
	ui_tab.crosshair_cone_color_picker.color=sg["crosshair_color"]
	ui_tab.crosshair_cone_size.value=sg["cone_crosshair_size"]


	game_tab.max_enemy_count_slider.value = sg["max_enemy_count"]
	game_tab.set_enemy_count_label(sg["max_enemy_count"])

func store_settings()->void:
	var sg = SaveManager.get_options_save()

	sg["sfx_volume"] = db2linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	sg["music_volume"] = db2linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sg["sfx_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("SFX"))
	sg["music_disabled"] = AudioServer.is_bus_mute(AudioServer.get_bus_index("Music"))

	sg["blood_overlay_enabled"]=ui_tab.blood_on_screen_toggle.pressed
	sg["crosshair_type"] = ui_tab.current_crosshair
	sg["crosshair_is_dynamic"]=ui_tab.crosshair_dynamic_toggle.pressed
	sg["crosshair_color"] = ui_tab.crosshair_color_picker.color.to_html()
	sg["crosshair_size"] = ui_tab.crosshair_size.value
	sg["cone_crosshair_is_dynamic"] = ui_tab.crosshair_cone_dynamic_toggle.pressed
	sg["cone_crosshair_size"] = ui_tab.crosshair_cone_size.value

	sg["max_enemy_count"] = game_tab.max_enemy_count_slider.value
	sg["language"] = TranslationServer.get_locale()	
	
	#The according tabs are removed in android because none of the included settings make sense
	if !Globals.android:
		sg["fullscreen_enabled"] = OS.window_fullscreen
		sg["vsync_enabled"]= OS.vsync_enabled
		sg["zooming_inverted"]=controls_tab.zoom_inverted_toggle_button.pressed
		sg["key_bindings"] = SaveManager.get_serialized_inputmap()#controls_tab.get_key_binding_dict()


	SaveManager.set_options_save(sg)
