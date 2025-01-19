extends Node2D

export var patrol_range:float = 50
export var damage:int = 20
export var attack_range = 200


var movementNode:Movement = null
var team:int = -1 setget set_team
var possible_targets=[]
var target_player:KinematicBody2D = null



var ready_to_attack:bool = true
var alive:bool=true

enum STATE {PATROL,HUNT}
var state:int = STATE.PATROL
var patrol_destination:Vector2 = Vector2()

var max_attaention_radius:float = 10000
var attention_radius_gain:float = 10
var max_start_radius:float = 1000
var current_radius:float = 0


onready var game = get_node_or_null("/root/Game")
onready var cooldown_timer:Timer = $AttackCooldown
onready var attention_radius:CollisionShape2D = $AttentionRadius/CollisionShape2D
onready var reevaluation:Timer = $TargetReevaluation
onready var player:Player = null

func initialize(movementNode:Movement, team : int):
	self.movementNode = movementNode
	set_team(team)
	movementNode.connect("reached_destination",self,"_on_reached_destination")
	patrol_destination = create_random_patrol_location()
	current_radius = rand_range(0,max_start_radius)
	player = get_parent().player
	target_player = player
	reevaluation.wait_time = rand_range(15,45)
	reevaluation.start()
	#attention_radius.shape.radius = rand_range(0,max_start_radius)


func _process(delta):
	if !alive or get_parent().freeze_amount >= 1:
		return

	if state == STATE.HUNT:
		if target_player != null and target_player.get_global_position().distance_to(self.get_global_position()) < attack_range:
			#print("stop")
			movementNode.stop_movement()
			if ready_to_attack:
				attack()
		else:
			movementNode.set_destination(target_player.global_position)
	else:#state patrol
		if attention_radius == null:
			return
		if target_player.get_global_position().distance_squared_to(self.get_global_position()) < current_radius*current_radius:
			state = STATE.HUNT
			return
		current_radius += attention_radius_gain*delta
		movementNode.set_destination(patrol_destination)


func set_team(new_team:int) -> void:
	team = new_team

func create_random_patrol_location() -> Vector2:
	if game.spawner ==null:
		var random_x=rand_range(-patrol_range, patrol_range)#allways returns same numbers, if seed isnt changed at each playtrough with randomize()
		var random_y=rand_range(-patrol_range, patrol_range)
		var origin = global_position
		return Vector2(random_x, random_y)+ origin
	else:
		return game.spawner.random_position_in_map()


func attack()->void:
	get_parent().animation_player.play("Attack")#triggers actual attack_2
	ready_to_attack = false
	cooldown_timer.start()

func attack_2()->void:
	player.take_damage(damage,self.get_parent())

func _on_AttackCooldown_timeout():
	ready_to_attack = true

func _on_reached_destination():
	patrol_destination = create_random_patrol_location()

func evaluate_targets():
	if len(possible_targets) == 0:
		return
	else:
		var closet = [possible_targets[0],possible_targets[0].get_global_position().distance_squared_to(self.get_global_position())]
		for t in possible_targets:
			var dist_squared = t.get_global_position().distance_squared_to(self.get_global_position())
			if dist_squared < closet[1]:
				closet = [t,dist_squared]
		target_player = closet[0]

func _on_AttentionRadius_body_entered(body):
	if body.is_in_group("Players"):
		state = STATE.HUNT
		possible_targets.append(body)
		evaluate_targets()


func _on_TargetReevaluation_timeout():
	evaluate_targets()
	reevaluation.wait_time = rand_range(15,45)
	reevaluation.start()
	if is_instance_valid(attention_radius):
		attention_radius.queue_free()
