extends VBoxContainer

onready var score_cont = $ScoreCont
onready var score_lab = $ScoreCont/Score

onready var time_cont = $TimeCont
onready var time_lab = $TimeCont/Time

func show_score(score:int) -> void:
	score_cont.visible=true
	score_lab.text=str(score)
func show_time(time:int) -> void:
	time_cont.visible=true
	time_lab.text=time_to_str(time)
func time_to_str(time:int) -> String:
	var minutes = time / 60
	var seconds = time % 60
	var str_time = "%02d:%02d" % [minutes, seconds]
	return str_time
