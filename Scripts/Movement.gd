extends Node2D
class_name Movement

#export var speed: float = 75
export var rotation_speed:float = 0.1

var speed: float = 75

var actor:KinematicBody2D = null
var animation_player:AnimationPlayer = null
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

func move_to(location:Vector2):
	movement_vector = vector_to(location)*speed
	lerp_location = location
	
	
	#actor.move_and_slide(movement_vector)
	#lerp_rotate_toward(location)
func stop_movement():
	if not is_moving():
		return
	movement_vector = Vector2.ZERO
	animation_player.queue("halt")

func is_moving():
	return (movement_vector != Vector2.ZERO)

func _physics_process(delta):
	if movement_vector != Vector2.ZERO:
		if animation_player.current_animation != "walk":
			animation_player.play("walk")
		actor.move_and_slide(movement_vector)
		lerp_rotate_toward(lerp_location)
