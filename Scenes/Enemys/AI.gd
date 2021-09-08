extends Node2D

export var patrol_range:float = 50


var movementNode:Movement = null
var team:int = -1 setget set_team
var player:KinematicBody2D = null

#func _process(delta):
#	movementNode.move_to(create_random_patrol_location())

func initialize(movementNode:Movement, team : int):
	self.movementNode = movementNode
	set_team(team)
	#self.player = player
	#movementNode.move_to(create_random_patrol_location())

func set_team(new_team:int):
	team = new_team

func create_random_patrol_location() -> Vector2:
	var random_x=rand_range(-patrol_range, patrol_range)#allways returns same numbers, if seed isnt changed at each playtrough with randomize()
	var random_y=rand_range(-patrol_range, patrol_range)
	var origin = global_position
	return Vector2(random_x, random_y)+ origin
	
func _process(delta):
	if player.get_global_position().distance_to(self.get_global_position()) < 200:
		#print("stop")
		movementNode.stop_movement()
	else:
		movementNode.move_to(player.global_position)
