extends Node
class_name ControllerFocusManagement

signal focuse_recieved
export(NodePath) var overwrite_focus_object

onready var focus_object = get_node_or_null(overwrite_focus_object)

func _ready():
	if focus_object==null:
		focus_object=get_parent()

func receive_focus():
	Globals.add_focus_manager(self)
	if is_instance_valid(focus_object):
		if focus_object.has_method("receive_focus"):
			focus_object.receive_focus()
		elif focus_object.has_method("grab_focus"):
			focus_object.grab_focus()
	else:
		print_debug("No focus object.")

func return_focus():
	var super_control = Globals.get_super_focus()
	if is_instance_valid(super_control):
		super_control.receive_focus()
	
