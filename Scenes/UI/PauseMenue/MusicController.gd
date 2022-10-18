extends HBoxContainer

onready var info_label = get_node('%TrackInfoLabel')

var music_player:BackgroundMusic = null#is gotten from globals after it was set there



func _ready():
	Globals.connect("music_player_set",self,"set_music_player")#Tells us that the music player was set in globals

func set_music_player()->void:
	if is_instance_valid(Globals.music_player):
		music_player = Globals.music_player
		music_player.connect("track_changed",self,"_on_track_changed")

func set_info_label(title:String,artist:String)->void:
	var text = "%s - %s" % [title,artist]
	info_label.text = text

func _on_SkipButton_pressed()->void:
	music_player.skip_track()


# warning-ignore:unused_argument
func _on_LoopButton_toggled(button_pressed)->void:
	music_player.loop = !music_player.loop

func _on_track_changed(path_to_track:String)->void:
	"""
	For this to work properly, the files have to be named accordingly: Ttile_Artist_EverythingElse
	"""
	var file_name = path_to_track.split("/")[-1]
	var track_splited = file_name.split("_")
	if track_splited.size() >= 2:
		set_info_label(track_splited[0],track_splited[1])

