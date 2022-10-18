extends Timer
class_name EffectBasis

export (Texture)var icon_texture
export (PackedScene)var image_container


onready var player = get_parent()
onready var game = get_node_or_null("/root/Game")

var icon:TextureRect  = null

func _ready():
	if game != null:
		icon= image_container.instance()
		icon.texture = icon_texture
		var container = game.gui.effect_container
		container.add_child(icon)
	add_effect()

# warning-ignore:unused_argument
func _process(delta):
	var scroller:float = time_left/wait_time
	icon.material.set_shader_param("scroller",scroller)

func add_effect():
	pass

func remove_effect():
	pass

func _on_EffectBasis_timeout():
	remove_effect()
	if icon !=null:
		icon.queue_free()
	queue_free()

