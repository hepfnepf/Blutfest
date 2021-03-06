extends GridContainer

onready var fps = $FPS
onready var enemys = $Enemys
onready var nodes = $Nodes

var alive = true

func _ready():
	set_alive(false)

func _process(delta):
	if !alive:
		return
	fps.text = str(Performance.get_monitor(Performance.TIME_FPS))
	nodes.text = str(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))

func _on_enemy_count_changed():
	var enemy_count = get_tree().get_nodes_in_group("ENEMIES").size()
	enemys.text = str(enemy_count)

func set_alive(new_alive):
	if new_alive == alive:
		return

	for child in get_children():
		child.visible = new_alive

	alive = new_alive

