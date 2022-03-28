extends Weapon



#Change how the spread changes are influenced by the players movement
export (float) var standing_spread_decrease_multiplyer = 1.0
export (float) var walking_spread_increase_multiplyer = 1.0

#Differentiates the amount of movement. velocity below will count as standing. above will count as walking
export (float) var standing_walking_differ = 0.2

func decrease_spread(delta:float):
	if !is_reloading:
		if player.velocity.length()  < standing_walking_differ:
			spread -= spread_dec*delta * standing_spread_decrease_multiplyer
		else:
			spread -= spread_dec*delta
		if spread < base_spread:
			spread = base_spread
	emit_signal("spread_changed", spread)

func increase_spread():
	if player.velocity.length()  < standing_walking_differ:
		spread *= 1+spread_inc
	else:
		spread *= 1+spread_inc*walking_spread_increase_multiplyer
	if spread > max_spread:
		spread = max_spread
	emit_signal("spread_changed", spread)
