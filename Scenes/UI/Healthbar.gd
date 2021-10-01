extends HBoxContainer

onready var prog_bar = $ProgressBar
onready var label = $Label

func set_health(new_health):
	if new_health <= 0:
		new_health = 0
	prog_bar.value = new_health
	#var format_string:String = %s / 
	var max_health = label.text.split("/")[1]
	label.text =" %s/%s" % [str(new_health),max_health]
func set_max_health(new_max_health):
	prog_bar.max_value = new_max_health
	var curr_health = label.text.split("/")[0]
	label.text =" %s/%s" % [curr_health,str(new_max_health)]
