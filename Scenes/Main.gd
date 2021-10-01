extends Node2D

export (PackedScene) var death_screen_prefab

onready var gui = $GUI
onready var player = $Player

func _ready():
	player.connect("dead",self,"_on_player_death")
	gui.set_player(player)

func _on_player_death():
	var death_screen = death_screen_prefab.instance()
	add_child(death_screen)
	death_screen.set_score(player.score)
	death_screen.set_time(player.elapsed_time)
	
func _on_enemy_killed(points):
	print("brumm")
	player.set_score(player.score + points)
