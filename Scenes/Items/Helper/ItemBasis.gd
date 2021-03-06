extends Area2D
class_name Item

export (float) var pop_up_time = 1.0
export (float) var time_to_despawn = 30

var time_of_blink:float = 10
var is_blinking:bool = false
var blink_to_zero:bool=false

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

func pick_up(player:Player):
	queue_free()

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




func _on_FadeOut_tween_completed(object, key):
	queue_free()


func _on_FadeIn_tween_completed(object, key):
	if key == ":modulate:a":
		if blink_to_zero:
			blink_to_zero=false
			tween_in.interpolate_property(self,"modulate:a",null,1.0,1.0)
			tween_in.start()
		else:
			blink_to_zero=true
			tween_in.interpolate_property(self,"modulate:a",null,0.0,1.0)
			tween_in.start()

