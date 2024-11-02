extends Node
##
## This is a helping scene for spotting issues with translation.
##

onready var file = 'res://Localization/Translation.csv'
onready var locales = TranslationServer.get_loaded_locales()

func _ready() -> void:
	test_file()

func test_file()->void:
	var f = File.new()
	f.open(file, File.READ)
	f.get_line()#skip firsl line, which contains only locales
	var i:int = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		test_line(line,i)
		i+=1
	f.close()
	get_tree().quit()

func test_line(line:String,number:int)->void:
	if line=="":
		print_debug("Empty line: Line %d"%number)
		return

	var key:String = line.split(",")[0]
	for locale in locales:
		TranslationServer.set_locale(locale)
		var trans:String = TranslationServer.translate(key)
		check_translation(key,trans)
	##

func check_translation(key:String,translation:String)->void:
	if key==translation:
		print_debug("Issue detected: Translation equals key.")
		print_debug(key,translation)
	if translation[0]== " ":
		print_debug("Issue detected: Translation begins with whitespace.")
		print_debug(key,translation)
