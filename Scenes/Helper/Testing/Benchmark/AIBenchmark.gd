extends "res://Scenes/Enemys/AI.gd"

func perform_state_patrol(delta):
	if attention_radius == null:
		return
	movementNode.set_destination(patrol_destination)
