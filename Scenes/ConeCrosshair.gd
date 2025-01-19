extends Sprite

#Here dynamic referes to the length. The cone always portrays the right spread, because its useless otherwise


export(float) var STATIC_LENGTH = 10.0

var dynamic:bool = true
var max_range:float = 10 setget set_cone_range #gets set from the weapon when added to player
var spread:float = 0.2
var size:float = 1.0

func _ready() -> void:
	init_values()
	EventBus.connect("crosshair_color_change",self,"_on_crosshair_color_change")
	EventBus.connect("cone_crosshair_is_dynamic",self,"_on_crosshair_is_dynamic_change")
	EventBus.connect("cone_crosshair_size_change",self,"_on_crosshair_size_change")
	EventBus.connect("settings_reset",self,"init_values")
	EventBus.connect("crosshair_type_changed",self,"_on_crosshair_type_change")


func init_values()->void:
	var color = SaveManager.current_save_options["crosshair_color"]
	dynamic = SaveManager.current_save_options["cone_crosshair_is_dynamic"]
	size = SaveManager.current_save_options["cone_crosshair_size"]

	_on_crosshair_color_change(color)
	_on_crosshair_is_dynamic_change(dynamic)
	_on_crosshair_type_change(SaveManager.current_save_options["crosshair_type"])

#send and connected from the weapon
func _on_spread_change(spread:float)->void:
	material.set("shader_param/spread",spread)

func _on_crosshair_color_change(new_color:Color)->void:
	material.set("shader_param/color",new_color)

func _on_crosshair_is_dynamic_change(is_dynamic:bool)->void:
	dynamic = is_dynamic
	if dynamic:
		set_cone_range(max_range)
	else:
		scale=Vector2(STATIC_LENGTH*size,STATIC_LENGTH*size)


func _on_crosshair_size_change(_size:float)->void:
	if not dynamic:
		scale = STATIC_LENGTH*Vector2(_size,_size)
	size = _size

func set_cone_range(length:float)->void:
	if dynamic:
		#The last factor is a scaling constant, since the cone flows to an alpha of 0, an exact scaling would look wrong, because the cone appears to not reach the last pixels
		#The *2 is because we only use half of the image in the shader( where UV.x >0.5)
		var _scale = length/texture.get_size().x*2.0*1.12*get_parent().range_multi
		scale = Vector2(_scale,_scale)
	max_range = length

func _on_crosshair_type_change(new_crosshair_type:int)->void:
	if new_crosshair_type in [Globals.CrosshairType.CONE,Globals.CrosshairType.BOTH]:
		visible = true
	else:
		visible = false
