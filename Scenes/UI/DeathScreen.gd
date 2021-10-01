extends CanvasLayer


onready var scoreLabel = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/GridContainer/Score
onready var timeLabel = $MarginContainer/VBoxContainer/CenterContainer2/MarginContainer/GridContainer/Time

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_score(score):
	scoreLabel.text = str(score)

func set_time(time):
	var minutes = time / 60
	var seconds = time % 60
	var str_time = "%02d:%02d" % [minutes, seconds]
	timeLabel.text = str_time
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	if Input.is_action_pressed("Escape"):
		 get_tree().quit()
	if Input.is_action_pressed("Enter"):
		get_tree().reload_current_scene()
