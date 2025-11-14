extends RichTextLabel

onready var file = 'res://Credits.txt'

func _ready():
	bbcode_text=load_file(file)

func load_file(file) -> String:
	var f = File.new()
	f.open(file, File.READ)
	var txt = ""
	#var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		line += " "
		txt += line + '\n'
	f.close()
	return txt

func _process(delta):
	if Input.is_action_pressed("ui_down"):
		get_v_scroll().value += 1
	elif Input.is_action_pressed("ui_up"):
		get_v_scroll().value -= 1
