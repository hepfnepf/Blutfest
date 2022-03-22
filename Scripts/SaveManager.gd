extends Node


var savegame = File.new()
var save_path = "user://savegame.save"
var save_dict = {"highscore":0,"best_time":0}

func create_save():
	savegame.open(save_path,File.WRITE)
	savegame.store_var(save_dict)
	savegame.close()

func save(save_dict):
	self.save_dict = save_dict
	#save_dict["highscore"] = highscore
	#save_dict["best_time"] = best_time

	if not savegame.file_exists(save_path):
		create_save()
		return
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_dict)
	savegame.close()
	print("wrote:\n",save_dict)

func read_savegame():
	if not savegame.file_exists(save_path):
		print("Nothing here")
		create_save()
	savegame.open(save_path, File.READ) #open the file
	save_dict = savegame.get_var() #get the value
	if save_dict == null:
		print("Error while retriving file. Coruppted File. Overwrite with new one. ")
		create_save()
	savegame.close() #close the file
	print("read:\n",save_dict)
	return save_dict #return the value
