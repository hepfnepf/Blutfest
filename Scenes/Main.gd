extends Node2D
signal killed_enemy

export (PackedScene) var death_screen_prefab

onready var gui = $GUI
onready var map = $Map
onready var player:Player = $Player
onready var spawner:Spawner = $Spawner
onready var debug_gui = $GUI/HUD/VBoxContainer/DebugLayout
onready var time_manager = get_node("/root/TimeManager")

var enemys_alive:int = 0
var enemy_hpbars_enabled:bool=false #gets set by debug menu

func _ready()-> void:
	randomize()
	initial_spawning()
	player.connect("dead",self,"_on_player_death")
	connect("killed_enemy",debug_gui,"_on_enemy_count_changed")
	BulletPool.connect("bullet_count_changed", debug_gui,"_on_bullet_count_changed")
	gui.set_player(player)
	gui.set_cursor(Cursor.CURSOR_TYPE.CROSSHAIR)
	time_manager.set_time_scale(1.0)
	var map_size:Vector2 = map.get_map_size()
	spawner.set_map_size(map_size[0],map_size[1])
	Globals.game = self
	get_tree().paused = false


	#Retrieve settings
	var sg = SaveManager.get_options_save()
	gui.pause_menu.sfx_slider.value_change_code(sg["sfx_volume"])
	gui.pause_menu.music_slider.value_change_code(sg["music_volume"])
	player.camera.invert_zooming = sg["zooming_inverted"]


#spawns some enemys around the player at the start of the game
func initial_spawning()->void:
	var MAX_DISTANCE:int= 5000
	var MIN_DISTANCE:float = 600.0
	var INITIAL_ENEMY_COUNT:int = 25

	var i:int = 0
	while i < INITIAL_ENEMY_COUNT:

		var pos = Vector2((randf()*2-1) *MAX_DISTANCE,(randf()*2-1) *MAX_DISTANCE)
		if pos.length()>MIN_DISTANCE:
			spawner.spawn_at(spawner.default_enemy,pos,true,true)
			i+=1

func _on_player_death()->void:
	var death_screen = gui.death_screen
	spawner.game_alive = false
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	var save_dict= SaveManager.get_game_save()
	death_screen.handle_score_display(save_dict["highscore"],player.score,save_dict["best_time"],player.elapsed_time)
	death_screen.populate_stats(player)

	var change:bool=false
	if save_dict["highscore"] < player.score:
		save_dict["highscore"] = player.score
		change=true
	if save_dict["best_time"] < player.elapsed_time:
		save_dict["best_time"] = player.elapsed_time
		change=true

	if change:
			SaveManager.set_game_save(save_dict)

func restart()->void:
	BulletPool.clear_all_bullets()
	get_tree().reload_current_scene()

func _on_enemy_killed() -> void:
	enemys_alive -=1
	emit_signal("killed_enemy")


