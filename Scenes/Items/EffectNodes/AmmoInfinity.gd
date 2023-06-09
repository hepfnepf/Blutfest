extends EffectBasis

export (float) var fire_rate_multiplyer = 3.0

var reload_time_delta = 0
var fire_rate_delta = 0

var weapon:Weapon=null

func _ready() -> void:
	if is_instance_valid(player.weapon):
		player.weapon.connect("weapon_switch",self,"_on_weapon_switch")

func add_effect():
	if player.weapon.current_weapon is Weapon:

		weapon = player.weapon.current_weapon
		weapon.ammo_infinity_stack += 1

		#Increase fire rate
		var new_fire_rate = int(weapon.fire_rate*fire_rate_multiplyer)
		fire_rate_delta = new_fire_rate - weapon.fire_rate
		weapon.fire_rate_delta += fire_rate_delta
		weapon.set_fire_rate(new_fire_rate)

		#Skip reloading
		if weapon.is_reloading:
			weapon.instant_finish_reloading()

func remove_effect():
	if is_instance_valid(weapon):
		weapon.ammo_infinity_stack -= 1
		weapon.fire_rate_delta -= fire_rate_delta
		weapon.set_fire_rate(weapon.fire_rate - fire_rate_delta)

func _on_weapon_switch(_weapon)->void:
	if is_instance_valid(player.weapon):
		add_effect()

