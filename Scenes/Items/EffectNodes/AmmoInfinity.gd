extends EffectBasis

export (float) var fire_rate_multiplyer = 3.0

var reload_time_delta = 0
var fire_rate_delta = 0

var weapon:Weapon=null
func add_effect():
	if player.Weapon.current_weapon is Weapon:
		#Skipping reload
		weapon = player.Weapon.current_weapon
		reload_time_delta = -weapon.reload_time
		weapon.reload_time_delta += reload_time_delta
		weapon.reload_time = 0

		#Increase fire rate
		var new_fire_rate = int(weapon.fire_rate*fire_rate_multiplyer)
		fire_rate_delta = new_fire_rate - weapon.fire_rate
		weapon.fire_rate_delta += fire_rate_delta
		weapon.set_fire_rate(new_fire_rate)

func remove_effect():
	if is_instance_valid(weapon):
		weapon.reload_time_delta -= reload_time_delta
		weapon.reload_time = weapon.reload_time - reload_time_delta

		weapon.fire_rate_delta -= fire_rate_delta
		weapon.set_fire_rate(weapon.fire_rate - fire_rate_delta)

