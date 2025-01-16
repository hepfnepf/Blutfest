extends Weapon

# Standard Rifle
# Features 2 effect:
#	- increases the likliehood of other weapon pop up spawning while equipped
#	- gives the player 2x points and exp, until the first shot misses
#

export (float) var weapon_spawn_rate_multi = 2.5
var effect_todo:bool=false

func add_to_player() -> void:
	effect_todo = true #cant directly call the effect since the spawner might does not exist yet
	.add_to_player()
	if player.standard_rifle_multi_enabled:
		player.standard_rifle_multi = 2.0

func _process(delta) -> void:
	._process(delta)
	if effect_todo:
		game.spawner.mult_all_weapon_probs(weapon_spawn_rate_multi)
		effect_todo = false

func remove_from_player():
	game.spawner.mult_all_weapon_probs(1/weapon_spawn_rate_multi)
	.remove_from_player()
	player.standard_rifle_multi = 1.0
