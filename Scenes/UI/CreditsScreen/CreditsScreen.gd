extends MarginContainer

onready var credits = $ColorRect/MarginContainer/VBoxContainer/RichTextLabel

onready var file = 'res://Credits.txt'

func _ready():
	credits.text=load_file(file)

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

func hide_background_color():
	$ColorRect.color = Color(0,0,0,0)

func _on_ExitButton_pressed():
	visible = false
