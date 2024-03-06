extends Perk

export(PackedScene)var tit_for_tats_bad_effect

func add_effect():
	player.tit_for_tat_good_multi = 2.0
	player.add_child(tit_for_tats_bad_effect.instance())

