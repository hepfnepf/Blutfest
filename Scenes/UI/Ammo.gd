extends VBoxContainer


onready var curr_ammo = $HBoxContainer/CurrentAmmo
onready var max_ammo = $HBoxContainer/MaxAmmo
onready var reload_progress = $ProgressBar

func set_ammo(new_ammo):
	curr_ammo.text = str(new_ammo)

func set_max_ammo(new_max_ammo):
	max_ammo.text = str(new_max_ammo)
