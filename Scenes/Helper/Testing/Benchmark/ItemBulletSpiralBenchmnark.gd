extends "res://Scenes/Items/Items/ItemBulletSpiral.gd"

func _ready() -> void:
	is_active = true
	timer.paused = true

func _on_Duration_timeout():
	return

func pick_up(player:Player):
	return
