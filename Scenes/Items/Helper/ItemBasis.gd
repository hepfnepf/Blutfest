extends Area2D
class_name Item
##
## This script defines the basic propertys of an item. It is not meant to be used directly, but to inherit from.
##
## @desc:
##     This creates an item that fades in, stays a while and fades out. It can be picked up by the player.
##     The behaviout when picked up gets defined in pick_up().
##
##
##
export (float) var pop_up_time = 1.0
export (float) var time_to_despawn = 30.0

var time_of_blink:float = 10
var is_blinking:bool = false
var blink_to_zero:bool=false
var explosion_size:float = 2.0

onready var timer:Timer = $Despawn
onready var tween_in:Tween=$FadeIn
onready var tween_out:Tween=$FadeOut

func _ready():
	var current_scale:Vector2 = transform.get_scale()
	if not Engine.editor_hint:

		#Else the a item would pop up and disappear if placed via editor in the game, if the item uses "tool", to be able to execute code in the editor

		scale = Vector2(0,0)
		#var current_scale:Vector2 = transform.get_scale()
		tween_in.interpolate_property(self,"scale",Vector2(0,0),current_scale,pop_up_time)
		tween_in.start()

		timer.start(time_to_despawn-time_of_blink)

func increase_lifetime(time):

	#The area effect items delete the timer when triggered, but still exist to perform the effect
	if !is_instance_valid(timer):
		return


	if is_blinking:
		is_blinking = false
		timer.start(timer.time_left+time)
	else:
		timer.start(timer.time_left+time+time_of_blink)

func pick_up(player:Player):
	player.create_explosion(player.exp_damage, explosion_size)
	queue_free()

func explode_if_enabled(player)->void:
	if player.items_explode:
		player.create_explosion(player.exp_damage, explosion_size)

func blink() -> void:
	is_blinking = true
	tween_in.interpolate_property(self,"modulate:a",null,0.0,1.0)
	blink_to_zero=true
	tween_in.start()
	#$Sprite.material.set_shader_param("is_blinking",is_blinking)

func _on_Despawn_timeout():
	if is_blinking:
		tween_out.interpolate_property(self,"scale",null,Vector2(0,0),0.3)
		tween_out.start()
	else:
		blink()
		timer.start(time_of_blink)



# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_FadeOut_tween_completed(object, key):
	queue_free()


# warning-ignore:unused_argument
func _on_FadeIn_tween_completed(object, key):
	tween_in.remove_all()
	if key == ":modulate:a":
		if blink_to_zero or !is_blinking:
			blink_to_zero=false
			tween_in.interpolate_property(self,"modulate:a",null,1.0,1.0)
			tween_in.start()
		else:
			blink_to_zero=true
			tween_in.interpolate_property(self,"modulate:a",null,0.0,1.0)
			tween_in.start()

