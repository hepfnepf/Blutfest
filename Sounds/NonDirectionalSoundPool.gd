extends Node

var sound_queue:Queue = Queue.new()


"""
Plays a sound using the sound pool. volume must be given in linear
"""
func play_sound(stream:AudioStream,volume:float)->void:
	var _streamer:AudioStreamPlayer = sound_queue.pop()
	if _streamer == null:
		_streamer = AudioStreamPlayer.new()
		_streamer.bus = "SFX"
		add_child(_streamer)

	_streamer.stream = stream
	_streamer.set_volume_db(linear2db(volume))
	_streamer.play()

	yield(_streamer, "finished")
	sound_queue.add(_streamer)
