extends Node

const VERSION :int=2

"""
Manages the save game. Stores and reads data.

Also features some advanced features:
	- check if the save game was made in the games version and maybe need to be updatet
	- error tolerant: incompatible attributes get ignored
	- integrity check
	- create backups of non compatible saves before overwriting them
"""
var savegame = File.new()
var save_game_path = "user://savegame.save"
const new_save_game_dict = {
	"version":VERSION,
	"highscore":0,
	"best_time":0,
	}

var saveOptions = File.new()
var save_options_path = "user://saveOptions.save"
const new_save_options_dict = {
	"version":VERSION,
	"sfx_volume":0.5,
	"sfx_disabled":false,
	"music_volume":0.5,
	"music_disabled":false,
	"fullscreen_enabled":false,
	"vsync_enabled":true,
	"zooming_inverted":false,
	"blood_overlay_enabled":true,
	"crosshair_type":Globals.CrosshairType.CROSSHAIR,
	"crosshair_is_dynamic":true,
	"cone_crosshair_is_dynamic":true,
	"crosshair_color":"#ff408acf",
	"crosshair_size":1.0,
	"cone_crosshair_size":1.0,
	"max_enemy_count":250,
	"language":"",
	"key_bindings":{}
	}

var standard_keybindings={}
var initial_language=""


onready var current_save_game= read_savegame()
onready var current_save_options=read_saveOptions()



func _ready() -> void:
	standard_keybindings = get_current_key_binding_dict()
	initial_language = TranslationServer.get_locale()
	init_game()

"""
To be used directly:
"""

func get_game_save()->Dictionary:
	return current_save_game.duplicate()

func get_options_save()->Dictionary:
	return current_save_options.duplicate()

func set_game_save(game_save:Dictionary)->void:
	var res = import_save_game(game_save)
	if res[0]:
		alert_player("The game data to be saved does not pass the integrity check. Writing cleaned up data instead.")
	current_save_game=res[1]
	write_save_game_to_file(current_save_game)

func set_options_save(options_save:Dictionary)->void:
	var res = import_save_options(options_save)
	if res[0]:
		alert_player("The game data to be saved does not pass the integrity check. Writing cleaned up data instead.")
	current_save_options=res[1]
	write_save_options_to_file(current_save_options)

"""
								The rest of this script is mostly not meant to be acessed directly from other scripts!
"""

func init_game()->void:
	load_key_binding(current_save_options["key_bindings"])
	if current_save_options["language"] != "":
		TranslationServer.set_locale(current_save_options["language"])
	else:
		TranslationServer.set_locale(initial_language)
	EventBus.emit_signal("blood_overlay_enabled",current_save_options["blood_overlay_enabled"])
	EventBus.emit_signal("max_enemy_count_change",current_save_options["max_enemy_count"])
	EventBus.emit_signal("blood_overlay_enabled",current_save_options["blood_overlay_enabled"])
	OS.window_fullscreen = current_save_options["fullscreen_enabled"]
	OS.vsync_enabled=current_save_options["vsync_enabled"]
	EventBus.emit_signal("fullscreen_changed")
	EventBus.emit_signal("vsync_changed")
	EventBus.emit_signal("zooming_inverted",current_save_options["zooming_inverted"])

	var sfx_index= AudioServer.get_bus_index("SFX")
	var music_index= AudioServer.get_bus_index("Music")
	var sfx_db_value = linear2db(current_save_options["sfx_volume"])
	var music_db_value = linear2db(current_save_options["music_volume"])
	var sfx_muted = current_save_options["sfx_disabled"]
	var music_muted = current_save_options["music_disabled"]
	AudioServer.set_bus_volume_db(sfx_index, sfx_db_value)
	AudioServer.set_bus_volume_db(music_index, music_db_value)
	AudioServer.set_bus_mute(sfx_index,sfx_muted)
	AudioServer.set_bus_mute(music_index,music_muted)
	
	#Set to android mode
	if OS.get_name()=="Android":
		Globals.android=true
		current_save_options["crosshair_type"] = Globals.CrosshairType.CONE
	
	


func reset_key_bindings()->void:
	load_key_binding(standard_keybindings)
	current_save_options["key_bindings"]={}


func get_current_key_binding_dict()->Dictionary:
	var bindings = {}
	var actions = InputMap.get_actions()
	for action in actions:
		bindings[action] = serialize_action(action)

	return bindings


func load_key_binding(bindings:Dictionary)->void:
	#print_debug(bindings)
	for action in bindings:
		if not bindings[action].empty():
			InputMap.action_erase_events(action)
			for event_dict in bindings[action]:
				var event = deserialize_event(bindings[action][event_dict])
#				if event is InputEventJoypadButton:
#					print_debug(action, ": ", event.as_text())
#					print_debug("Device: ", Input.get_joy_name(event.device))
#					print_debug("Button: ", Input.get_joy_button_string(event.button_index))
				if  not event is InputEventKey or event.scancode != 0:
					InputMap.action_add_event(action,event)
					#print_debug(action,event)

# gets an dict like {button_index:0, device:0, type:InputEventJoypadButton}
func deserialize_event(event_dict:Dictionary)->InputEvent:
	if event_dict["type"]=="InputEventKey":
		return deserialize_key_event(event_dict)
	if event_dict["type"]=="InputEventJoypadButton":
		return deserialize_controller_button_event(event_dict)
	if event_dict["type"]=="InputEventJoypadMotion":
		return deserialize_controller_joystick_event(event_dict)
	if event_dict["type"]=="InputEventMouseButton":
		return deserialize_mouse_button(event_dict)
	return null

func deserialize_key_event(event_dict:Dictionary)->InputEventKey:
	assert(event_dict["type"] == "InputEventKey")
	var event:InputEventKey = InputEventKey.new()
	event.device = event_dict["device"]
	event.alt = event_dict["alt"]
	event.command = event_dict["command"]
	event.control = event_dict["control"]
	event.meta = event_dict["meta"]
	event.shift = event_dict["shift"]
	event.echo = event_dict["echo"]
	event.pressed = event_dict["pressed"]
	event.scancode = event_dict["scancode"]
	event.unicode = event_dict["unicode"]
	return event

func deserialize_controller_button_event(event_dict:Dictionary)->InputEventJoypadButton:
	assert (event_dict["type"]== "InputEventJoypadButton")
	var event:InputEventJoypadButton = InputEventJoypadButton.new()
	event.device = event_dict["device"]
	event.button_index = event_dict["button_index"]	
	return event

func deserialize_controller_joystick_event(event_dict:Dictionary)->InputEventJoypadMotion:
	assert(event_dict["type"]== "InputEventJoypadMotion")
	var event:InputEventJoypadMotion = InputEventJoypadMotion.new()
	event.axis=event_dict["axis"]
	event.device=event_dict["device"]
	event.axis_value=event_dict["direction"]
	return event

func deserialize_mouse_button(event_dict:Dictionary)->InputEventMouseButton:
	assert(event_dict["type"]=="InputEventMouseButton")
	var event:InputEventMouseButton = InputEventMouseButton.new()
	event.device=event_dict["device"]
	event.button_index=event_dict["index"]
	return event

#Only max. one binding of each type per action
#If no event was found, an empty dict gets returned
func serialize_action(action:String)->Dictionary:
	var event_dict:Dictionary = {}
	for event in InputMap.get_action_list(action):
		if event is InputEventKey:
			event_dict["InputEventKey"] = serialize_key_event(event)
		if event is InputEventJoypadButton:
			event_dict["InputEventJoypadButton"]=serialize_controller_button_event(event)
		if event is InputEventJoypadMotion:
			event_dict["InputEventJoypadMotion"]= serialize_controller_joystick_event(event)
		if event is InputEventMouseButton:
			event_dict["InputEventMouseButton"]=serialize_mouse_button(event)
	return event_dict

func get_serialized_inputmap()->Dictionary:
	var bindings = {}
	var actions = InputMap.get_actions()
	for action in actions:
		bindings[action] = SaveManager.serialize_action(action)
	return bindings

func serialize_key_event(event:InputEventKey)->Dictionary:
	var toStore ={
		"type":"InputEventKey",
		"device":event.device,
		"alt":event.alt,
		"command":event.command,
		"control":event.control,
		"meta":event.meta,
		"shift":event.shift,
		"echo":event.echo,
		"pressed":event.pressed,
		"scancode":event.scancode,
		"unicode":event.unicode
	}
	return toStore

func serialize_controller_button_event(event:InputEventJoypadButton)->Dictionary:
	var toStore = {
		"type":"InputEventJoypadButton",
		"device":event.device,
		"button_index":event.button_index
	}
	
	return toStore

func serialize_controller_joystick_event(event:InputEventJoypadMotion)->Dictionary:
	var toStore = {
		"type":"InputEventJoypadMotion",
		"device":event.device,
		"axis":event.axis,
		"direction":event.axis_value
	}
	
	return toStore

func serialize_mouse_button(event:InputEventMouseButton)->Dictionary:
	var toStore= {
		"type":"InputEventMouseButton",
		"device":event.device,
		"index":event.button_index,
	}
	print_debug(toStore)
	return toStore

"""
Create new save files with base values.
"""
func create_empty_save_game_file()->void:
	write_save_game_to_file(new_save_game_dict)

func create_empty_save_options_file()->void:
	write_save_options_to_file(new_save_options_dict)

"""
Store a dict in the save files. Create file if it not yet exists.
"""
func write_save_game_to_file(_save_game_dict)->void:
	savegame.open(save_game_path, File.WRITE)
	var json_string = JSON. print(_save_game_dict)
	savegame.store_string(json_string)
	savegame.close()

func write_save_options_to_file(_save_options_dict)->void:
	saveOptions.open(save_options_path, File.WRITE)
	var json_string = JSON.print(_save_options_dict)
	saveOptions.store_string(json_string)
	saveOptions.close()

"""
Read save files, return dict.
"""
func read_savegame()->Dictionary:
	if not savegame.file_exists(save_game_path):
		alert_player("No save game found. Creating a new one.")
		create_empty_save_game_file()
		Globals.first_start = true
		return new_save_game_dict

	savegame.open(save_game_path, File.READ) #open the file
	var _save_game_dict = null
	var json_result:JSONParseResult = JSON.parse(savegame.get_as_text())
	if !json_result.error == OK:
		print_debug("JSON parsing error in save game: %s\nin Line: %s"%[json_result.error_string,json_result.error_line])
		_save_game_dict = new_save_game_dict.duplicate()
	else:
		_save_game_dict = json_result.result
	savegame.close()

	if _save_game_dict == null or typeof(_save_game_dict)!= TYPE_DICTIONARY :
		alert_player("Error while retriving file. Coruppted File. Backing up and writing a new one.")
		back_up_save_file(_save_game_dict,save_game_path)

		create_empty_save_game_file()
		return new_save_game_dict

	if !_save_game_dict.has("version"):
		alert_player("Unknown version number of game save file. Trying to salvage data, but some issues might occur. Please check if the save file is valid!")
		back_up_save_file(_save_game_dict,save_game_path)

	else:
		if _save_game_dict["version"] != VERSION:
			#In this case, the save game has been created using a different verion of the savemanager and needs to be converted
			if _save_game_dict["version"] > VERSION:
				alert_player("Game savefile has been created by a newer version. Trying to salvage data, but some issues might occur.")
				back_up_save_file(_save_game_dict,save_game_path)
			if _save_game_dict["version"] < VERSION:
				alert_player("Game savefile has been created by an older version. Upgrading data...")
				back_up_save_file(_save_game_dict,save_game_path)

				performe_upgrade_steps_save_game(_save_game_dict)

	var res = import_save_game(_save_game_dict)# [0]: where there issues with the input? If yes we store the cleaned up version. [1]:the cleaned up dict
	_save_game_dict=res[1]
	if res[0]:
		write_save_game_to_file(_save_game_dict)
	return _save_game_dict

func read_saveOptions()->Dictionary:
	if not saveOptions.file_exists(save_options_path):
		alert_player("No settings file found. Creating a new one.")
		create_empty_save_options_file()
		return new_save_options_dict

	saveOptions.open(save_options_path, File.READ)
	var _save_options_dict = null
	var json_result:JSONParseResult = JSON.parse(saveOptions.get_as_text())
	if !json_result.error == OK:
		print_debug("JSON parsing error in options save: %s\nin Line: %s"%[json_result.error_string,json_result.error_line])
		_save_options_dict = new_save_game_dict.duplicate()
	else:
		_save_options_dict = json_result.result
	saveOptions.close()

	if _save_options_dict == null or typeof(_save_options_dict)!= TYPE_DICTIONARY:
		alert_player("Error while retriving file. Coruppted File. Overwrite with new one.")
		back_up_save_file(_save_options_dict,save_options_path)

		create_empty_save_options_file()
		return new_save_options_dict

	if !_save_options_dict.has("version"):
		alert_player("Unknown version number of settings file. Trying to salvage data, but some issues might occur. Please check if the save file is valid!")
		back_up_save_file(_save_options_dict,save_options_path)

	else:
		if _save_options_dict["version"] != VERSION:
			#In this case, the save options has been created using a different verion of the savemanager and needs to be converted
			if _save_options_dict["version"] > VERSION:
				alert_player("Settings savefile has been created by a newer version. Trying to salvage data, but some issues might occur.")
				back_up_save_file(_save_options_dict,save_options_path)
			if _save_options_dict["version"] < VERSION:
				alert_player("Settings savefile has been created by an older version. Upgrading data...")
				back_up_save_file(_save_options_dict,save_options_path)

				performe_upgrade_steps_save_options(_save_options_dict)

	var res= import_save_options(_save_options_dict)
	_save_options_dict=res[1]
	if res[0]:
		write_save_options_to_file(_save_options_dict)
	return _save_options_dict


#Gets the read save game file dict and returns a new save game dict, while doing correction of possible errors.
func import_save_game(save_game:Dictionary):
	var new_save_game = new_save_game_dict.duplicate()
	var needed_change:bool=false
	for key in new_save_game:
		if save_game.has(key):
			if check_key_constraints_game_save(key,save_game[key]):
				new_save_game[key]=save_game[key]
			else:
				needed_change=true
		else:
			needed_change=true
	return [needed_change,new_save_game]


#Gets the read options save file dict and returns a new save options dict, while doing correction of possible errors.
func import_save_options(save_options:Dictionary):
	var new_save_options = new_save_options_dict.duplicate()
	var needed_change:bool=false
	for key in new_save_options:
		if save_options.has(key):
			if check_key_constraints_options_save(key,save_options[key]):
				new_save_options[key]=save_options[key]
			else:
				needed_change = true
		else:
			needed_change = true
	return [needed_change,new_save_options]

"""
Error handling and version conversion.
"""

func back_up_save_file(save_dict:Dictionary, orig_path:String)->void:
	var backup = File.new()
	var i:int = 0
	while backup.file_exists(orig_path+".bak."+str(i)):
		i+=1
	backup.open(orig_path+".bak."+str(i),File.WRITE)
	backup.store_var(save_dict)
	backup.close()


# check if a cartain value in dict fullfills needed constraints
func check_key_constraints_game_save(key,value)->bool:
	if key=="version":
		if value != VERSION:
			return false
	if key=="highscore":
		if value < 0:
			var msg:String="Invalid save game value for the parameter %s. Highscore cant be negative"%key
			printerr(msg)
			return false
	if key=="best_time":
		if value < 0:
			var msg:String="Invalid save game value for the parameter %s. Best time cant be negative"%key
			printerr(msg)
			return false
	return true

func check_key_constraints_options_save(key,value)->bool:
	if key=="version":
		if value != VERSION:
			return false
	return true


func performe_upgrade_steps_save_game(save_game):
	#var new_save_game = save_game
	for _i in range(save_game["version"],VERSION):
		perform_save_game_upgrade_step(save_game)
	#return new_save_game

func performe_upgrade_steps_save_options(save_options):
	#var new_save_option = save_options
	for _i in range(save_options["version"],VERSION):
		perform_save_options_upgrade_step(save_options)
	#return new_save_option

func perform_save_game_upgrade_step(save_game):
	#Savegame update steps. E.g
	#if save_game["version"]==1:
	#	save_game[example] = 2*save_game[example]
	pass

func perform_save_options_upgrade_step(save_options):
	#options save update steps. E.g if save_game["version"]==1:	...
	pass




func alert_player(msg:String)->void:
	printerr(msg)
	#maybe also create graphical popup
	pass
