extends Node

"""
Manages the save game. Stores and reads data.
"""
var savegame = File.new()
var save_path = "user://savegame.save"
var save_dict = {
	"highscore":0,
	"best_time":0,
	"sfx_volume":0.5,
	"music_volume":0.5,
	}

func create_save():
	savegame.open(save_path,File.WRITE)
	savegame.store_var(save_dict)
	savegame.close()

func save(_save_dict):
	if not savegame.file_exists(save_path):
		create_save()
		return

	savegame.open(save_path, File.WRITE)
	savegame.store_var(_save_dict)
	savegame.close()
	#print_debug("wrote:\n",_save_dict)

func read_savegame():
	if not savegame.file_exists(save_path):
		print_debug("Nothing here")
		create_save()

	savegame.open(save_path, File.READ) #open the file

	var _save_dict = savegame.get_var() #get the value
	if _save_dict == null or _save_dict.size() != save_dict.size():
		print("Error while retriving file. Coruppted File. Overwrite with new one. ")
		create_save()
	savegame.close() #close the file
	#print_debug("read:\n",_save_dict)
	return _save_dict #return the value

