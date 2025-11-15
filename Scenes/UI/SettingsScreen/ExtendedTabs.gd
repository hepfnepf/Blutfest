extends Tabs

export(NodePath) var first_focus

func _ready():
	get_parent().connect("tab_selected",self,"_on_tab_some_selected")

func _on_tab_some_selected(tab)->void:
	if tab==self.num
