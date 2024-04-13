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


	#Retrieve volume settings
	var sg = SaveManager.read_saveOptions()
	gui.pause_menu.sfx_slider.value_change_code(sg["sfx_volume"])
	gui.pause_menu.music_slider.value_change_code(sg["music_volume"])


func _on_player_death()->void:
	var death_screen = death_screen_prefab.instance()
	add_child(death_screen)
	spawner.game_alive = false
	Globals.cursor_manager.set_cursor(Cursor.CURSOR_TYPE.DEFAULT)
	var save_dict= SaveManager.read_savegame()
	death_screen.handle_score_display(save_dict["highscore"],player.score,save_dict["best_time"],player.elapsed_time)
	death_screen.populate_stats(player)
	if save_dict["highscore"] < player.score:
		save_dict["highscore"] = player.score
	if save_dict["best_time"] < player.elapsed_time:
		save_dict["best_time"] = player.elapsed_time

	SaveManager.save_game(save_dict)

func restart()->void:
	BulletPool.clear_all_bullets()
	get_tree().reload_current_scene()

func _on_enemy_killed(points) -> void:
	enemys_alive -=1
	player.add_points(points)
	#player.set_score(player.score + points)
	emit_signal("killed_enemy")

func _on_enemy_spawned() -> void:
	enemys_alive +=1

