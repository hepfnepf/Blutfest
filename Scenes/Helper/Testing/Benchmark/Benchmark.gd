extends "res://Scenes/Main.gd"

export (PackedScene) var zombie_animation_only
export (PackedScene) var zombie_ai
export (PackedScene) var bullet_spiral_scene

enum STAGES {RENDER_TEST,AI_TEST, BULLET_TEST, OFF}
var current_stage:int = STAGES.OFF

var last_spawn = 0

var PUFFER = 5 #how many seconds it has to be under the perfomance targets, for the test to end
var PERFORMANCE_TARGET = 60 #how many FPS are targeted

#helpers for individual stages

#stage 3
var bullet_spiral = null
var shooting_start = 0
var SHOOTING_RATE_MULTI = 1.0 #shooting_rate = seconds_since_begin_of_stage *SHOOTING_RATE_MULTI

func _ready() -> void:
	gui.crosshair.visible = false
	gui.crosshair.set_process(false)
	disable_node(player)
	disable_node(player.weapon.current_weapon)
	disable_node(spawner)
	var cursor_man = Globals.cursor_manager
	cursor_man.set_cursor(cursor_man.CURSOR_TYPE.DEFAULT)

	yield(get_tree().create_timer(5), "timeout")
	last_spawn = Time.get_ticks_msec()
	start_stage(STAGES.BULLET_TEST)


func _process(delta: float) -> void:
	debug_gui._on_enemy_count_changed()
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 1: Testing rendering of how many fps at MANY_ZOMBIEZ zombiez, no ai but animation
	if current_stage == STAGES.RENDER_TEST:
		perform_stage_animation()
	if current_stage == STAGES.AI_TEST:
		perform_stage_ai()
	if current_stage == STAGES.BULLET_TEST:
		perform_stage_bullet()


func start_stage(stage:int)->void:
	print_debug("Stopings stage: ", STAGES.keys()[current_stage])
	clear_enemies()
	current_stage = STAGES.OFF
	yield(get_tree().create_timer(5), "timeout")
	last_spawn = Time.get_ticks_msec()
	current_stage = stage
	print_debug("Starting stage: ", STAGES.keys()[stage])

	if stage == STAGES.BULLET_TEST:
		shooting_start = Time.get_ticks_msec()

	if stage == STAGES.OFF:
		clear_enemies()
		yield(get_tree().create_timer(5), "timeout")
		last_spawn = Time.get_ticks_msec()
		if is_instance_valid(bullet_spiral):
			bullet_spiral.queue_free()

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

	# Test 2:
	if fps >= PERFORMANCE_TARGET:
		spawner.spawn_at(zombie_ai,spawner.random_position_in_map())
		last_spawn = Time.get_ticks_msec()
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		start_stage(STAGES.BULLET_TEST)

func perform_stage_bullet()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 3:
	if fps >= PERFORMANCE_TARGET:
		#spawner.spawn_at(zombie_animation_only,spawner.random_position_in_map())
		if bullet_spiral ==null:
			bullet_spiral = bullet_spiral_scene.instance()
			add_child(bullet_spiral)

		var duration = Time.get_ticks_msec() - shooting_start
		var rate = duration/1000 * SHOOTING_RATE_MULTI
		if rate > 0:
			bullet_spiral.bullet_rate =rate

		last_spawn = Time.get_ticks_msec()

	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		start_stage(STAGES.OFF)




func disable_node(node)->void:
	node.set_physics_process(false)
	node.set_process(false)
	node.set_process_input(false)

func clear_enemies()->void:
	var enemys = get_tree().get_nodes_in_group("ENEMIES")
	for enemy in enemys:
		enemy.queue_free()
	pass
