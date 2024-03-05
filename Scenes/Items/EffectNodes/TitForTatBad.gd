extends Timer

onready var player:Player = get_parent()

func _ready() -> void:
	add_effect()
	player.connect("leveled_up",self,"_on_level_up")

func add_effect():
	player.tit_for_tat_bad_multi=4.0

func remove_effect():
	player.tit_for_tat_bad_multi=1.0

func _on_level_up()->void:
	remove_effect()
	queue_free()
