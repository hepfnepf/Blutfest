extends ColorRect

signal wave_finished

## This Rect includes the shader that draws the shockWave on the screen.
## It should be placed inside a canvas item node and be set to fill the whole screen.

export(float)var strength = 0.03
export(float)var duration = 1.0

func start(duration:float=self.duration,strength:float=self.strength,center:Vector2=Vector2(0.5,0.5)):
	var tween:SceneTreeTween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_method(self, "set_rad", 0.0, 1.5, duration)
	tween.tween_callback(self,"emit_signal",["wave_finished"])

func set_rad(radius):
	self.material.set("shader_param/radius",radius)
