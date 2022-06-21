extends EnemyEffectBasis

func add_effect():
	if enemy.has_method("freeze"):
		enemy.freeze()

func remove_effect():
	if enemy.has_method("unfreeze"):
		enemy.defreeze()

