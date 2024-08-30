extends Node

const VERSION :int=1
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
	"music_volume":0.5,
	}

onready var current_save_game= read_savegame()
onready var current_save_options=read_saveOptions()

"""
To be used directly:
"""

func get_game_save()->Dictionary:
	return current_save_game

func get_options_save()->Dictionary:
	return current_save_options

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
The rest of this script is not meant to be acessed directly from other scripts!
"""

"""
Create new save files with base values.
"""
func create_empty_save_game_file()->void:
	savegame.open(save_game_path,File.WRITE)
	savegame.store_var(new_save_game_dict)
	savegame.close()

func create_empty_save_options_file()->void:
	savegame.open(save_options_path,File.WRITE)
	savegame.store_var(new_save_options_dict)
	savegame.close()

"""
Store a dict in the save files. Create file if it not yet exists.
"""
func write_save_game_to_file(_save_game_dict)->void:
	savegame.open(save_game_path, File.WRITE)
	savegame.store_var(_save_game_dict)
	savegame.close()

func write_save_options_to_file(_save_options_dict)->void:
	saveOptions.open(save_options_path, File.WRITE)
	saveOptions.store_var(_save_options_dict)
	saveOptions.close()

"""
Read save files, return dict.
"""
func read_savegame()->Dictionary:
	if not savegame.file_exists(save_game_path):
		alert_player("No save game found. Creating a new one.")
		create_empty_save_game_file()
		return new_save_game_dict

	savegame.open(save_game_path, File.READ) #open the file
	var _save_game_dict = savegame.get_var() #get the dict
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
	var _save_options_dict = saveOptions.get_var()
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
func import_save_game(save_game):
	var new_save_game = new_save_game_dict.duplicate()
	var needed_change:bool=false
	for key in new_save_game:
		if save_game.has(key):
			if check_key_constraints_game_save(key,save_game[key]):
				new_save_game[key]=save_game[key]
			else:
				needed_change=true
	return [needed_change,new_save_game]


#Gets the read options save file dict and returns a new save options dict, while doing correction of possible errors.
func import_save_options(save_options):
	var new_save_options = new_save_options_dict.duplicate()
	var needed_change:bool=false
	for key in new_save_options:
		if save_options.has(key):
			if check_key_constraints_options_save(key,save_options[key]):
				new_save_options[key]=save_options[key]
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
	for i in range(save_game["version"],VERSION):
		perform_save_game_upgrade_step(save_game)
	#return new_save_game

func performe_upgrade_steps_save_options(save_options):
	#var new_save_option = save_options
	for i in range(save_options["version"],VERSION):
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
