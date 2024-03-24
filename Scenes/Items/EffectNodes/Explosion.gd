extends Node2D

var damage = 100.0

onready var anim:AnimationPlayer = $Node2D/AnimationPlayer
onready var area:Area2D = $Node2D/Area2D
onready var sound:AudioStreamPlayer2D = $Node2D/ExplosionSound

var already_hit = []
var anim_finished:bool = false
var sound_finished:bool = true
var alive:bool=true

func _ready() -> void:
	anim.play("explosion")
	if sound.stream != null:
		sound_finished=false
		sound.play()


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if alive:
		for body in area.get_overlapping_bodies():
				if body.is_in_group("ENEMIES") and !(body in already_hit):
					apply_effect(body)
					already_hit.append(body)

func apply_effect(body) -> void:
	if body.has_method("handle_hit"):
		body.handle_hit(damage, Globals.DamageType.EXPLOSION)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if (anim_name=="explosion"):
		anim_finished=true
		alive=false
		check_finished()
		#queue_free()

func _on_ExplosionSound_finished() -> void:
	sound_finished = true
	check_finished()


func check_finished()->void:
	if (anim_finished==true and sound_finished==true):
		queue_free()
