extends Popup

onready var health_gained_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/LeftRow/HealthGained/Label2
onready var shots_fired_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/LeftRow/ShotsFired/Label2
onready var enemies_killed_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/LeftRow/EnemiesKilled/Label2
onready var distance_covered_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/LeftRow/DistanceCovered/Label2
onready var powerups_collected_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/LeftRow/PowerUpsCollected/Label2
onready var favorite_weapons_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/LeftRow/FavoriteWeapon/Label2
onready var health_lost_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/RightRow/HealthLost/Label2
onready var accuracy_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/RightRow/Accuracy/Label2
onready var damage_caused_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/RightRow/DamageCaused/Label2
onready var standing_time_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/RightRow/StandingTime/Label2
onready var perks_collected_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/RightRow/PerksCollected/Label2
onready var favorite_powerups_label:Label = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CenterContainer/HBoxContainer/RightRow/FavoritePowerUps/Label2



func populate(player:Player)->void:
	health_gained_label.text = str(player.health_gained)
	shots_fired_label.text  = str(player.shots_fired)
	enemies_killed_label.text=str(player.enemies_killed)
	distance_covered_label.text=str(player.distance_covered)
	powerups_collected_label.text = str(add_all(player.power_ups_collected))
	favorite_weapons_label.text = get_favorite_weapon(player.weapon)
	health_lost_label.text = str(player.health_lost)
	accuracy_label.text = str(player.accuracy)
	damage_caused_label.text = str(player.damage_caused)
	standing_time_label.text = str(player.max_standing_time)
	perks_collected_label.text = str(player.perkManager.active_perks.size())
	favorite_powerups_label.text = get_favorite_powerup(player.power_ups_collected)


#TODO: this is basically the same as the favoriter powerup function, the searching dict for highest key-value pair should be its own function
func get_favorite_weapon(weapon)->String:
	weapon.add_weapon_to_stats()
	var weapon_time_dict=weapon.weapon_time_used

	assert(weapon_time_dict.size()>0, "Error in the weapon time dict. It seems to be empty.")
	var fav_weapon:String = weapon_time_dict.keys()[0]
	var fav_time = weapon_time_dict.values()[0]

	for key in weapon_time_dict.keys():
		if weapon_time_dict[key] > fav_time:
			fav_weapon=key
			fav_time= weapon_time_dict[key]

	#get name from path
	var name:String = fav_weapon.split("/")[-1].split(".")[0]

	return str(name)

func get_favorite_powerup(power_ups_collected)->String:
	if power_ups_collected.size()==0:
		return "No powerups collected"

	var fav_up = power_ups_collected.keys()[0]
	var fav_amnt=power_ups_collected.values()[0]

	for key in power_ups_collected.keys():
		if  power_ups_collected[key]>fav_amnt:
			fav_up=key
			fav_amnt=power_ups_collected[key]

	var name:String = fav_up.split("/")[-1].split(".")[0]
	return str(name)

func add_all(dict)->int:
	var sum:int=0
	for key in dict.keys():
		sum+=dict[key]
	return sum
