extends Area2D
class_name Item

export (float) var pop_up_time = 1.0
export (float) var time_to_despawn = 30

var time_of_blink:float = 10
var is_blinking:bool = false

onready var timer:Timer = $Despawn
onready var tween_in:Tween=$FadeIn
onready var tween_out:Tween=$FadeOut

func _ready():
	var current_scale:Vector2 = transform.get_scale()
	tween_in.interpolate_property(self,"scale",Vector2(0,0),current_scale,pop_up_time)
	tween_in.start()
	
	timer.start(time_to_despawn-time_of_blink)
	
func pick_up(player:Player):
	queue_free()

func blink() -> void:
	is_blinking = true
	$Sprite.material.set_shader_param("is_blinking",is_blinking)

func _on_Despawn_timeout():
	if is_blinking:
		tween_out.interpolate_property(self,"modulate:a",1,0,0.3)
		tween_out.start()
	else:
		blink()
		timer.start(time_of_blink)
	
	


func _on_FadeOut_tween_completed(object, key):
	queue_free()
