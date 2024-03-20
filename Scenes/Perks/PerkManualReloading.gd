extends Perk


export(float)var reload_reduction = 0.0
func add_effect()->void:
	player.manuel_reloading_perk=reload_reduction

func get_title()->String:
	return tr(title)

func get_desc()->String:
	return tr(desc)%(reload_reduction*100)
