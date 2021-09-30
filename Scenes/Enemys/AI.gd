extends Node2D

export var patrol_range:float = 50
export var damage:int = 20
export var attack_range = 200

var movementNode:Movement = null
var team:int = -1 setget set_team
var player:KinematicBody2D = null


var cooldown_timer:Timer = null
var ready_to_attack = true
#func _process(delta):
#	movementNode.move_to(create_random_patrol_location())

func initialize(movementNode:Movement, team : int,player):
	self.movementNode = movementNode
	set_team(team)
	self.player = player
	#self.player = player
	#movementNode.move_to(create_random_patrol_location())


func _process(delta):
	if player.get_global_position().distance_to(self.get_global_position()) < attack_range:
		#print("stop")
		movementNode.stop_movement()
		if ready_to_attack:
			attack(player)
	else:
		movementNode.move_to(player.global_position)



func set_team(new_team:int):
	team = new_team

func create_random_patrol_location() -> Vector2:
	var random_x=rand_range(-patrol_range, patrol_range)#allways returns same numbers, if seed isnt changed at each playtrough with randomize()
	var random_y=rand_range(-patrol_range, patrol_range)
	var origin = global_position
	return Vector2(random_x, random_y)+ origin
	

func attack(player):
	get_parent().animation_player.play("Attack")
	player.take_damage(damage)
	ready_to_attack = false
	cooldown_timer.start()


func _on_AttackCooldown_timeout():
	ready_to_attack = true
