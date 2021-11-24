extends Timer
class_name EffectBasis

var player = null

func _ready():
	player = get_parent()
	add_effect()

func add_effect():
	pass

func remove_effect():
	pass

func _on_EffectBasis_timeout():
	remove_effect()
	queue_free()

