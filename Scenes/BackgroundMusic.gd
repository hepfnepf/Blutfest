extends AudioStreamPlayer
class_name BackgroundMusic

signal track_changed(path_to_track)

export (Array, AudioStream) var tracks
export (Array, float) var volumes #used to normalize the tracks, volumes given in db

var currentIndex:int = 0
var loop:bool = false

func _ready()->void:
	if len(tracks) != len(volumes):
		print_debug("Not avery background track seems to have a volume given. The track and volume arrays have different legths.")
	Globals.music_player = self
	_on_BackgroundMusic_finished()


func _on_BackgroundMusic_finished()->void:
	if loop:#If looping is active, replay this track
		volume_db = volumes[currentIndex]
		play()
		emit_signal("track_changed",stream.resource_path)
		return

	if currentIndex+1 >= len(tracks) or currentIndex+1 >= len(volumes):
		tracks.shuffle()
		stream = tracks[0]
		currentIndex = 0
		volume_db = volumes[0]
		play()
		emit_signal("track_changed",stream.resource_path)
	else:
		currentIndex += 1
		stream = tracks[currentIndex]
		volume_db = volumes[currentIndex]
		play()
		emit_signal("track_changed",stream.resource_path)

func skip_track()->void:
	_on_BackgroundMusic_finished()

func set_loop(loop_status:bool)->void:
	loop = loop_status
