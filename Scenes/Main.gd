extends Node2D
signal killed_enemy


export (PackedScene) var death_screen_prefab

onready var gui = $GUI
onready var player = $Player
onready var spawner = $Spawner
onready var debug_gui = $GUI/MarginContainer/VBoxContainer/HBoxContainer3/DebugLayout

func _ready():
	player.connect("dead",self,"_on_player_death")
	connect("killed_enemy",debug_gui,"_on_enemy_count_changed")
	gui.set_player(player)

func _on_player_death():
	var death_screen = death_screen_prefab.instance()
	add_child(death_screen)
	death_screen.set_score(player.score)
	death_screen.set_time(player.elapsed_time)
	spawner.game_alive = false
	
func _on_enemy_killed(points):
	player.set_score(player.score + points)
	emit_signal("killed_enemy")
