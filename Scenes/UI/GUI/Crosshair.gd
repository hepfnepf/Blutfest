extends Node2D

onready var outer_crosshair = $OuterCrosshair
onready var inner_crosshair = $InnerCrosshair

export (float)var max_size = 1.0
export (float)var min_size = 0.5
export (float)var spread_scaler = 50.0

var dynamic:bool = true

func _ready() -> void:
	var color = SaveManager.current_save_options["crosshair_color"]
	dynamic = SaveManager.current_save_options["crosshair_is_dynamic"]
	outer_crosshair.material.set("shader_param/color",color)
	inner_crosshair.material.set("shader_param/color",color)
	EventBus.connect("crosshair_color_change",self,"_on_crosshair_color_change")
	EventBus.connect("crosshair_is_dynamic",self,"_on_crosshair_is_dynamic_change")
	EventBus.connect("crosshair_size_change",self,"_on_crosshair_size_change")

# warning-ignore:unused_argument
func _process(delta) -> void:
	global_position = get_viewport().get_mouse_position()

func set_spread(new_spread) -> void:
	if dynamic:
		var _spread =new_spread*spread_scaler
		_spread = sqrt(_spread)+(1/pow((_spread+1),2))*1/8
		_spread = clamp(_spread*1.1,min_size,max_size)
		outer_crosshair.scale = Vector2(_spread,_spread)
	else:
		outer_crosshair.scale = Vector2(1.0,1.0)

func _on_crosshair_color_change(new_color:Color)->void:
	outer_crosshair.material.set("shader_param/color",new_color)
	inner_crosshair.material.set("shader_param/color",new_color)

func _on_crosshair_is_dynamic_change(is_dynamic:bool)->void:
	dynamic = is_dynamic
	set_spread(1.0)

func _on_crosshair_size_change(size:float)->void:
	scale = Vector2(size,size)
