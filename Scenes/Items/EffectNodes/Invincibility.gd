extends EffectBasis


func add_effect():
	player.change_invincibility(+1)

func remove_effect():
	player.change_invincibility(-1)
