extends ProgressBar



#You might wonder:
#1.why the set_as_toplevel + the manualy setting its position to follow the parent?
#2.why the complicated showing logic?
#Answer:
#1.If the health bar is simply a child of the enemy, it will move along correctly, but rotate along the enemy as well.
#I always want the label to be above the enemy, regardless the orientation. Because of that, it gets set as toplevel.
#That decouples the transform of the parent and health bar. But that means i have to follow alonf the enemy manualy in the process function
#2.In the first frame, because of the decoupliung of 1., the health bar appears in the middle of the map, so it needs to be hidden.
#It should also be togglable weather health bars get shown at all, e.g. only in debug mode or with a perk.
#I also want to hide the healthbar, if its full, to declutter the display
var skip_frame:bool=true
var default_visible:bool=true #are health bars turned off/on
var should_be_visible:bool=false #if health!=maxhealth


onready var parent=get_parent()
onready var game = get_node_or_null("/root/Game")
onready var health_node = null

var offset_position = rect_position
func _ready() -> void:
	rect_global_position = parent.global_position + offset_position
	set_as_toplevel(true)
	skip_frame=true
	if game:
		default_visible=game.enemy_hpbars_enabled
	show_if_appropiate()


func _process(delta: float) -> void:
	rect_global_position = parent.global_position + offset_position
	if skip_frame:
		skip_frame=false
		show_if_appropiate()


func set_health(health)->void:
	value=health
	if max_value-value<=1:
		should_be_visible=false
	else:
		should_be_visible=true
	show_if_appropiate()

func set_max_health(max_health)->void:
	max_value=max_health

func show_if_appropiate()->void:
	if game:
		default_visible=game.enemy_hpbars_enabled

	if !skip_frame and default_visible and should_be_visible:
		show()
	else:
		hide()
