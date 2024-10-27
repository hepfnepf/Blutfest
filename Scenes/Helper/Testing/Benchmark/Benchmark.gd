extends "res://Scenes/Main.gd"
##
## This is a helping scene for benchmarking the game.
##
## @desc:
##      This benchmarking scene should be useful, to test performance on different devices, to undestand the perfomance implication of changes,
##      optimize performance, identify performance regressions and test different graphic settings.
##      For that, this scene works like a state machine, that performce a couple of becnhmarks(stages) after each other and writes the finings in to the console.
##      Usally, these stages increase an performance aspect (likes enemeies rendered on screen), until the fps is lower that PERFORMANCE_TARGET for PUFFER time.
##      Currently, this scene is meant to run within the editor, and can not be accessed in-game.
##
##

export (float)var PUFFER = 5.0 #how many seconds it has to be under the perfomance targets, for the test to end
export (float)var PERFORMANCE_TARGET = 60.0 #how many FPS are targeted

export (PackedScene) var zombie_animation_only
export (PackedScene) var zombie_ai
export (PackedScene) var bullet_spiral_scene

enum STAGES {RENDER_TEST,AI_TEST, BULLET_TEST, BULLET_ENEMY_TEST, END, OFF}
var current_stage:int = STAGES.OFF

#helpers for  stages
var last_spawn:int = 0 #used in calculating, if PUFFER time has been reched
var first_dip:int = 0


#stage BULLET_TEST and BULLET_ENEMY_TEST
var ENEMY_COUNT:int = 500
var bullet_spiral = null
var shooting_start:int = 0
var SHOOTING_RATE_MULTI:float = 1.0 #shooting_rate = seconds_since_begin_of_stage *SHOOTING_RATE_MULTI
var zombiez_spawned:int = 0

func _ready() -> void:
	gui.crosshair.visible = false
	gui.crosshair.set_process(false)
	disable_node(player)
	disable_node(player.weapon.current_weapon)
	disable_node(spawner)
	var cursor_man = Globals.cursor_manager
	cursor_man.set_cursor(cursor_man.CURSOR_TYPE.DEFAULT)
	display_introduction()

	yield(get_tree().create_timer(5), "timeout")
	last_spawn = Time.get_ticks_msec()
	switch_to_stage(STAGES.RENDER_TEST)

func _process(delta: float) -> void:
	debug_gui._on_enemy_count_changed()
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	if current_stage == STAGES.RENDER_TEST:
		perform_stage_render()
	if current_stage == STAGES.AI_TEST:
		perform_stage_ai()
	if current_stage == STAGES.BULLET_TEST:
		perform_stage_bullet()
	if current_stage == STAGES.BULLET_ENEMY_TEST:
		perform_stage_bullet_enemies()

func display_introduction()->void:
	print("Starting Benchmarking Process.")
	print("Performance Target: ", PERFORMANCE_TARGET)
	print("Puffer: ", PUFFER)

func switch_to_stage(stage:int)->void:
	print("Stopings stage: ", STAGES.keys()[current_stage])
	clear_enemies()
	if is_instance_valid(bullet_spiral):
		bullet_spiral.queue_free()
	current_stage = STAGES.OFF
	yield(get_tree().create_timer(5), "timeout")
	last_spawn = Time.get_ticks_msec()
	first_dip = 0
	current_stage = stage
	print("Starting stage: ", STAGES.keys()[stage])

	if stage == STAGES.BULLET_TEST or stage==STAGES.BULLET_ENEMY_TEST:
		shooting_start = Time.get_ticks_msec()

	if stage == STAGES.OFF:
		yield(get_tree().create_timer(5), "timeout")

	if stage == STAGES.END:
		yield(get_tree().create_timer(5), "timeout")
		get_tree().quit()


#
# Indivisual stages
#

# Tests the rendering of enemies. Spawnes animated zombies, until the performance falls below the targeted performance.
func perform_stage_render()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	if fps >= PERFORMANCE_TARGET:
		spawner.spawn_at(zombie_animation_only,spawner.random_position_in_map())
		last_spawn = Time.get_ticks_msec()
	else:
		if first_dip == 0:
			first_dip = get_tree().get_nodes_in_group("ENEMIES").size()
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		display_stage_render(get_tree().get_nodes_in_group("ENEMIES").size())
		switch_to_stage(STAGES.AI_TEST)

func display_stage_render(enemy_count:int)->void:
	print("Max. enemy count to sustain perfromance target for puffer time: ", enemy_count)
	print("Enemy count at first dip below performance target: ",first_dip)

# Tests the ai of enemies. Spawnes animated zombiez with AI, until the performance falls below the targeted performance
func perform_stage_ai()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 2:
	if fps >= PERFORMANCE_TARGET:
		spawner.spawn_at(zombie_ai,spawner.random_position_in_map())
		last_spawn = Time.get_ticks_msec()
	else:
		if first_dip == 0:
			first_dip = get_tree().get_nodes_in_group("ENEMIES").size()
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		display_stage_ai(get_tree().get_nodes_in_group("ENEMIES").size())
		switch_to_stage(STAGES.BULLET_TEST)

func display_stage_ai(enemy_count:int)->void:
	display_stage_render(enemy_count)

# Tests how many bullets van be handled, by spawning bullets until the performance falls below the targeted performance.
func perform_stage_bullet()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	if fps >= PERFORMANCE_TARGET:
		if not is_instance_valid(bullet_spiral):
			bullet_spiral = bullet_spiral_scene.instance()
			bullet_spiral.bullet_rate = 0.1
			add_child(bullet_spiral)

		var duration = Time.get_ticks_msec() - shooting_start
		var rate = duration/1000 * SHOOTING_RATE_MULTI
		if rate > 0:
			bullet_spiral.bullet_rate =rate

		last_spawn = Time.get_ticks_msec()
	else:
		if first_dip == 0:
			first_dip = BulletPool.bullets_active
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		display_stage_bullet(BulletPool.bullets_active)
		switch_to_stage(STAGES.BULLET_ENEMY_TEST)

func display_stage_bullet(bullet_count:int)->void:
	print("Max. active bullets to sustain perfromance target for puffer time: ", bullet_count)
	print("Bullet count at first dip below performance target: ",first_dip)

# Test the physic interaction of bullets and enemys, by first spawning a relevant amount of enemys, and than keep spawning bullets, until the performance falls below the targeted performance.
func perform_stage_bullet_enemies()->void:
	var fps = Performance.get_monitor(Performance.TIME_FPS)

	# Test 4:
	while zombiez_spawned < ENEMY_COUNT:
		spawner.spawn_at(zombie_animation_only,spawner.random_position_in_map())
		zombiez_spawned+=1


	if fps >= PERFORMANCE_TARGET:
		if not is_instance_valid(bullet_spiral):
			bullet_spiral = bullet_spiral_scene.instance()
			add_child(bullet_spiral)
			bullet_spiral.bullet_rate = 0.1

		var duration = Time.get_ticks_msec() - shooting_start
		var rate = duration/1000 * SHOOTING_RATE_MULTI
		if rate > 0:
			bullet_spiral.bullet_rate =rate

		last_spawn = Time.get_ticks_msec()
	else:
		if first_dip == 0:
			first_dip = BulletPool.bullets_active
	if Time.get_ticks_msec() > last_spawn + PUFFER * 1000:
		display_stage_bullet_enemies(BulletPool.bullets_active)
		switch_to_stage(STAGES.END)

func display_stage_bullet_enemies(bullet_count:int)->void:
	display_stage_bullet(bullet_count)


# Helpers
func disable_node(node)->void:
	node.set_physics_process(false)
	node.set_process(false)
	node.set_process_input(false)

func clear_enemies()->void:
	var enemys = get_tree().get_nodes_in_group("ENEMIES")
	for enemy in enemys:
		enemy.queue_free()
	pass
