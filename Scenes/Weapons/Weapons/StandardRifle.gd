extends Weapon

export (float) var weapon_spawn_rate_multi = 2.5
var effect_todo:bool=false

func add_to_player() -> void:
	effect_todo = true #cant directly call the effect since the spawner might does not exist yet

func _process(delta) -> void:
	._process(delta)
	if effect_todo:
		game.spawner.mult_all_weapon_probs(weapon_spawn_rate_multi)
		effect_todo = false

func remove_from_player():
	game.spawner.mult_all_weapon_probs(1/weapon_spawn_rate_multi)
