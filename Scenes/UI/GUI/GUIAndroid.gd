extends "res://Scenes/UI/GUI/GUI.gd"

onready var lock_button = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/LockButton

func set_variables()->void:
	health_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HealthWidget
	exp_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ExpbarWidget
	ammo_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer2/AmmoWidget
	score = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer3/ScoreWidget/Score
	time = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/TimeWidget/Time
	debug_info = $HUD/VBoxContainer/DebugLayout
	crosshair = $Crosshair
	effect_container = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/EffectContainer
	credits = $PauseMenu/CreditsScreen
	pause_menu =$PauseMenu
	card_holder = $CardHolder
	instructions = $HUD/InstructionsPopup
	blood= $ScreenBlood
	weapon_info = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/VBoxContainer2/WeaponInfo
	death_screen  = $DeathScreen

func set_lock(new_lock:bool)->void:
	lock_button.switch_to_lockstate(new_lock)
