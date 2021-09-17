extends HBoxContainer


onready var prog_bar = $ProgressBar
onready var label = $Label

func set_exp(new_exp):
	prog_bar.value = new_exp
	#var format_string:String = %s / 
	var max_exp = label.text.split("/")[1]
	label.text =" %s/%s" % [str(new_exp),max_exp]
func set_max_exp(new_max_exp):
	prog_bar.max_value = new_max_exp
	var curr_exp = label.text.split("/")[0]
	label.text =" %s/%s" % [curr_exp,str(new_max_exp)]
