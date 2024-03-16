extends GridContainer

onready var fps:Label = $FPS
onready var enemys:Label = $Enemys
onready var nodes:Label = $Nodes
onready var bullet:Label = $Bullets
onready var difficulty:Label = $Difficulty
onready var spawn_rate:Label = $EnemySpawnRate

onready var game = get_node_or_null("/root/Game")
var alive = true

func _ready():
	set_alive(false)

# warning-ignore:unused_argument
func _process(delta):
	if !alive:
		return
	fps.text = str(Performance.get_monitor(Performance.TIME_FPS))
	nodes.text = str(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))

func _on_enemy_count_changed():
	var enemy_count = get_tree().get_nodes_in_group("ENEMIES").size()
	enemys.text = str(enemy_count)

func set_alive(new_alive:bool):
	if new_alive == alive:
		return

	for child in get_children():
		child.visible = new_alive

	alive = new_alive
	game.enemy_hpbars_enabled = new_alive

func _on_bullet_count_changed(new_bullet_count,new_bullet_active_count):
	var txt= "%s/%s/%s" % [new_bullet_count, new_bullet_active_count, new_bullet_count-new_bullet_active_count]
	bullet.text=txt

func _on_difficulty_changed(health, damage, speed, view_range,enemy_spawn_rate):
	var txt = "%.3f/%.3f/%.3f/%.3f" % [health,damage, speed, view_range]
	difficulty.text = txt
	spawn_rate.text = "%.3f" % enemy_spawn_rate

