extends HBoxContainer


onready var prog_bar:ProgressBar = $ProgressBar
onready var label:Label = $Label

func set_exp(new_exp):
	prog_bar.value = new_exp

	var max_exp = label.text.split("/")[1]
	label.text ="XP: %s/%s" % [str(new_exp),max_exp]
func set_max_exp(new_max_exp):
	prog_bar.max_value = new_max_exp
	var curr_exp = label.text.split("/")[0].split(":")[1]
	label.text ="XP: %s/%s" % [curr_exp,str(new_max_exp)]
