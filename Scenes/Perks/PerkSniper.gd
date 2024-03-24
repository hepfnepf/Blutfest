extends Perk


export(float)var zoom = 6.0

func add_effect()->void:
	player.camera.zoom=Vector2(zoom,zoom)
