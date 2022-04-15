extends AudioStreamPlayer
class_name BackgroundMusic

signal track_changed(path_to_track)

export (Array, AudioStream) var tracks

## Key = track object, value = volume_db float
export (Dictionary) var volumes

var currentIndex:int = 0
var loop:bool = false

func _ready()->void:
	if len(tracks) != len(volumes):
		print_debug("Not avery background track seems to have a volume given. The track and volume arrays have different legths.")
	Globals.music_player = self
	_on_BackgroundMusic_finished()



func _on_BackgroundMusic_finished()->void:
	if loop:#If looping is active, replay this track
		play_track(currentIndex)
		return

	if currentIndex+1 >= len(tracks) or currentIndex+1 >= len(volumes):
		tracks.shuffle()
		currentIndex=0
		play_track(currentIndex)
	else:
		currentIndex += 1
		play_track(currentIndex)

func play_track(index:int)->void:
	if index < len(tracks):
		if volumes.has(tracks[index]):
			volume_db = volumes[tracks[index]]
		else:
			volume_db = 0
			print_debug("Track %d does not have a volume." % index)
		stream = tracks[index]
	else:
		print_debug("Track %d does not exist." % index)
	play()
	emit_signal("track_changed",stream.resource_path)

func skip_track()->void:
	_on_BackgroundMusic_finished()

func set_loop(loop_status:bool)->void:
	loop = loop_status
