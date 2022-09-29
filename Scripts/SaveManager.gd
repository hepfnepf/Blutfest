extends Node

"""
Manages the save game. Stores and reads data.
"""
var savegame = File.new()
var save_game_path = "user://savegame.save"
var save_game_dict = {
	"highscore":0,
	"best_time":0,
	}

var saveOptions = File.new()
var save_options_path = "user://saveOptions.save"
var save_options_dict = {
	"sfx_volume":0.5,
	"music_volume":0.5,
	}

"""
Create new empty save files.
"""
func create_save_game()->void:
	savegame.open(save_game_path,File.WRITE)
	savegame.store_var(save_game_dict)
	savegame.close()

func create_save_options()->void:
	savegame.open(save_options_path,File.WRITE)
	savegame.store_var(save_options_dict)
	savegame.close()

"""
Store a dict in the save files.
"""
func save_game(_save_game_dict)->void:
	if not savegame.file_exists(save_game_path):
		create_save_game()
		return

	saveOptions.open(save_game_path, File.WRITE)
	saveOptions.store_var(_save_game_dict)
	saveOptions.close()

func save_options(_save_options_dict)->void:
	if not saveOptions.file_exists(save_options_path):
		create_save_options()
		return

	savegame.open(save_options_path, File.WRITE)
	savegame.store_var(_save_options_dict)
	savegame.close()

"""
Read save files, return dict.
"""
func read_savegame():
	if not savegame.file_exists(save_game_path):
		print_debug("Nothing here")
		create_save_game()

	savegame.open(save_game_path, File.READ) #open the file

	var _save_game_dict = savegame.get_var() #get the value
	if _save_game_dict == null or _save_game_dict.size() != save_game_dict.size():
		print("Error while retriving file. Coruppted File. Overwrite with new one. ")
		create_save_game()
		_save_game_dict = save_game_dict
	savegame.close() #close the file
	#print_debug("read:\n",_save_game_dict)
	return _save_game_dict #return the value

func read_saveOptions():
	if not saveOptions.file_exists(save_options_path):
		print_debug("Nothing here")
		create_save_options()

	saveOptions.open(save_options_path, File.READ) #open the file

	var _save_options_dict = saveOptions.get_var() #get the value
	if _save_options_dict == null or _save_options_dict.size() != save_options_dict.size():
		print("Error while retriving file. Coruppted File. Overwrite with new one. ")
		create_save_options()
		_save_options_dict = save_options_dict
	saveOptions.close() #close the file

	#print_debug("read:\n",_save_game_dict)
	return _save_options_dict #return the value
