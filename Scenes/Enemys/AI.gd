extends Node2D

export var patrol_range:float = 50
export var damage:int = 20
export var attack_range = 200


var movementNode:Movement = null
var team:int = -1 setget set_team
var player:KinematicBody2D = null



var ready_to_attack = true
var alive=true

enum STATE {PATROL,HUNT}
var state:int = STATE.HUNT
var patrol_destination:Vector2 = Vector2()


onready var game = get_node_or_null("/root/Game")
onready var cooldown_timer:Timer = $AttackCooldown

func initialize(movementNode:Movement, team : int,player):
	self.movementNode = movementNode
	set_team(team)
	self.player = player
	movementNode.connect("reached_destination",self,"_on_reached_destination")
	patrol_destination = create_random_patrol_location()



func _process(delta):
	if !alive:
		return
	
	if state == STATE.HUNT:
		if player.get_global_position().distance_to(self.get_global_position()) < attack_range:
			#print("stop")
			movementNode.stop_movement()
			if ready_to_attack:
				attack(player)
		else:
			movementNode.set_destination(player.global_position)
	else:#state patrol
		movementNode.set_destination(patrol_destination)


func set_team(new_team:int) -> void:
	team = new_team

func create_random_patrol_location() -> Vector2:
	if game.spawner ==null:
		var random_x=rand_range(-patrol_range, patrol_range)#allways returns same numbers, if seed isnt changed at each playtrough with randomize()
		var random_y=rand_range(-patrol_range, patrol_range)
		var origin = global_position
		print(Vector2(random_x, random_y)+ origin)
		return Vector2(random_x, random_y)+ origin
	else:
		return game.spawner.random_position_in_map()
	

func attack(player):
	get_parent().animation_player.play("Attack")
	player.take_damage(damage)
	ready_to_attack = false
	cooldown_timer.start()


func _on_AttackCooldown_timeout():
	ready_to_attack = true

func _on_reached_destination():
	patrol_destination = create_random_patrol_location()
