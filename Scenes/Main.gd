extends Node2D

onready var gui = $GUI
onready var player = $Player

func _ready():
	$Zombie/AI.player = player
	gui.set_player(player)
