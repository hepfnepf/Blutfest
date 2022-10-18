extends Timer
class_name EnemyEffectBasis

onready var enemy = get_parent()
onready var game = get_node_or_null("/root/Game")

var icon:TextureRect  = null

func _ready():
	add_effect()

# warning-ignore:unused_argument
func _process(delta):
	pass

func add_effect():
	pass

func remove_effect():
	pass

func _on_EffectBasis_timeout():
	remove_effect()
	queue_free()

