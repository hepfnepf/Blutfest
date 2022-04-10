extends AudioStreamPlayer
class_name BackgroundMusic

signal track_changed(path_to_track)

export (Array, AudioStream) var tracks


var currentIndex:int = 0
var loop:bool = false

func _ready()->void:
	Globals.music_player = self
	_on_BackgroundMusic_finished()


func _on_BackgroundMusic_finished()->void:
	if loop:#If looping is active, replay this track
		play()
		emit_signal("track_changed",stream.resource_path)
		return

	if currentIndex+1 >= len(tracks):
		tracks.shuffle()
		stream = tracks[0]
		currentIndex = 0
		play()
		emit_signal("track_changed",stream.resource_path)
	else:
		currentIndex += 1
		stream = tracks[currentIndex]
		play()
		emit_signal("track_changed",stream.resource_path)

func skip_track()->void:
	_on_BackgroundMusic_finished()

func set_loop(loop_status:bool)->void:
	loop = loop_status
