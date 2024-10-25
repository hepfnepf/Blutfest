extends "res://Scenes/Main.gd"

export (PackedScene) var zombie_animation_only
export (PackedScene) var zombie_ai

enum STAGES {RENDER_TEST,AI_TEST,OFF}
var current_stage:int = STAGES.OFF

var last_spawn = 0

var PUFFER = 5 #how many seconds it has to be under the perfomance targets, for the test to end
var PERFORMANCE_TARGET = 60 #how many FPS are targeted

func _ready() -> void:
	#._ready()
	gui.crosshair.visible = false
	gui.crosshair.set_process(false)
	disable_node(player)
	disable_node(player.weapon.current_weapon)
	disable_node(spawner)
	#spawner.enemy_spawn_rate_increase = 0.0
	#spawner.enemy_spawn_rate= 0.0
	var cursor_man = Globals.cursor_manager
	cursor_man.set_cursor(cursor_man.CURSOR_TYPE.DEFAULT)

	yield(get_tree().create_timer(5), "timeout")
	last_spawn = Time.get_ticks_msec()
	start_stage(STAGES.RENDER_TEST)

func start_stage(stage:int)->void:
	print_debug("Stopings stage: ", STAGES.keys()[current_stage])
	clear_enemies()
	current_stage = STAGES.OFF
	yield(get_tree().create_timer(5), "timeout")
	last_spawn = Time.get_ticks_msec()
	current_stage = stage
	print_debug("Starting stage: ", STAGES.keys()[stage])

	if stage == STAGES.OFF:
		clear_enemies()
		yield(get_tree().create_timer(5), "timeout")
		last_spawn = Time.get_ticks_msec()

func perform_stage_animation()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 1: Testing rendering of how many fps at MANY_ZOMBIEZ zombiez, no ai but animation
	if fps >= PERFORMANCE_TARGET:
		spawner.spawn_at(zombie_animation_only,spawner.random_position_in_map())
		last_spawn = Time.get_ticks_msec()
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		start_stage(STAGES.AI_TEST)

func perform_stage_ai()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 1: Testing rendering of how many fps at MANY_ZOMBIEZ zombiez, no ai but animation
	if fps >= PERFORMANCE_TARGET:
		spawner.spawn_at(zombie_ai,spawner.random_position_in_map())
		last_spawn = Time.get_ticks_msec()
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		start_stage(STAGES.OFF)

func _process(delta: float) -> void:
	debug_gui._on_enemy_count_changed()
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 1: Testing rendering of how many fps at MANY_ZOMBIEZ zombiez, no ai but animation
	if current_stage == STAGES.RENDER_TEST:
		perform_stage_animation()
	if current_stage == STAGES.AI_TEST:
		perform_stage_ai()


func disable_node(node)->void:
	node.set_physics_process(false)
	node.set_process(false)
	node.set_process_input(false)

func clear_enemies()->void:
	var enemys = get_tree().get_nodes_in_group("ENEMIES")
	for enemy in enemys:
		enemy.queue_free()
	pass
