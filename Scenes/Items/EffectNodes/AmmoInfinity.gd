extends EffectBasis

export (float) var fire_rate_multiplyer = 3.0

var reload_time_delta = 0
var fire_rate_delta = 0

var _weapon:Weapon=null

func add_effect():

	if player.weapon.current_weapon is Weapon:
		#Skipping reload
		_weapon = player.weapon.current_weapon
		reload_time_delta = -_weapon.reload_time
		_weapon.reload_time_delta += reload_time_delta
		_weapon.reload_time = 0

		#Increase fire rate
		var new_fire_rate = int(_weapon.fire_rate*fire_rate_multiplyer)
		fire_rate_delta = new_fire_rate - _weapon.fire_rate
		_weapon.fire_rate_delta += fire_rate_delta
		_weapon.set_fire_rate(new_fire_rate)

func remove_effect():
	if is_instance_valid(_weapon):
		_weapon.reload_time_delta -= reload_time_delta
		_weapon.reload_time = _weapon.reload_time - reload_time_delta

		_weapon.fire_rate_delta -= fire_rate_delta
		_weapon.set_fire_rate(_weapon.fire_rate - fire_rate_delta)

