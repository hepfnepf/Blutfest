extends Node2D
class_name Movement

signal reached_destination

#export var speed: float = 75
export var rotation_speed:float = 0.1

var speed: float = 75

var actor:KinematicBody2D = null
var animation_player:AnimationPlayer = null

var destination:Vector2 = Vector2.ZERO
var has_destination:bool = false

var movement_vector:Vector2 = Vector2.ZERO
var lerp_location:Vector2 = Vector2.ZERO

func initialize(actor:KinematicBody2D, animation_player: AnimationPlayer):
	self.actor = actor
	self.animation_player = animation_player
	#animation_player.play("Walk")

func lerp_rotate_toward(location: Vector2):
	actor.rotation = lerp_angle(actor.rotation, actor.global_position.direction_to(location).angle(),0.1)

func vector_to(location: Vector2):
	return actor.global_position.direction_to(location)

func set_destination(location:Vector2):
	destination = location
	has_destination = true

func stop_movement():
	if not is_moving():
		return
	has_destination = false
	animation_player.stop()
	movement_vector = Vector2.ZERO
	#animation_player.queue("halt")

func reached_destination():
	stop_movement()
	emit_signal("reached_destination")

func is_moving():
	return (movement_vector != Vector2.ZERO)

func _physics_process(delta):
	if has_destination:
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
		
		movement_vector = vector_to(destination).normalized()*speed
		if speed*speed > actor.position.distance_squared_to(destination):#prevents stepping over target at high speed
			actor.move_and_collide(vector_to(destination))
			reached_destination()
		else:
			actor.move_and_collide(movement_vector*delta)
		lerp_rotate_toward(destination)
