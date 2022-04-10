extends AudioStreamPlayer
class_name BackgroundMusic
export (Array, AudioStream) var tracks


var currentIndex:int = 0

func _ready():
	_on_BackgroundMusic_finished()


func _on_BackgroundMusic_finished():
	if currentIndex+1 >= len(tracks):
		tracks.shuffle()
		stream = tracks[0]
		currentIndex = 0
		play()
	else:
		currentIndex += 1
		stream = tracks[currentIndex]
		play()
