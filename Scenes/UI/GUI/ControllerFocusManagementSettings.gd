extends ControllerFocusManagement


## Exteds the regular ControllerFocusManagement node
## To have one focus element for each settings tab

export(NodePath) var game_tab_default
export(NodePath) var ui_tab_default
export(NodePath) var controls_tab_default
export(NodePath) var sound_tab_default
export(NodePath) var graphics_tab_default
export(NodePath) var language_tab_default

onready var focus_elements = []
func _ready():
	# Fails if we add an extra tab but dont change this class
	assert($"%TabContainer".get_child_count()==6, "Did you add the default focus element for the new settings tab? If so, increase comparision value.")
	
	create_focus_element_array()

func create_focus_element_array()->void:
	focus_elements.push_back(get_node_or_null(game_tab_default))
	focus_elements.push_back(get_node_or_null(ui_tab_default))
	focus_elements.push_back(get_node_or_null(controls_tab_default))
	focus_elements.push_back(get_node_or_null(sound_tab_default))
	focus_elements.push_back(get_node_or_null(graphics_tab_default))
	focus_elements.push_back(get_node_or_null(language_tab_default))


func _on_TabContainer_tab_selected(tab):
	focus_elements[tab].grab_focus()
