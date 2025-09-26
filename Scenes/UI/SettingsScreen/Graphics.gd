extends Tabs


func _ready():
	if Globals.android:
		queue_free()
