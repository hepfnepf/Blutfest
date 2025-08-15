extends "res://Scenes/UI/GUI/GUI.gd"

func set_variables()->void:
	health_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HealthWidget
	exp_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ExpbarWidget
	ammo_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/VBoxContainer2/AmmoWidget
	score = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer3/ScoreWidget/Score
	time = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/TimeWidget/Time
	debug_info = $HUD/VBoxContainer/DebugLayout
	lock_texture  = $HUD/VBoxContainer/HBoxContainer/LockSymbol
	crosshair = $Crosshair
	effect_container = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/EffectContainer
	credits = $PauseMenu/CreditsScreen
	pause_menu =$PauseMenu
	card_holder = $CardHolder
	instructions = $HUD/InstructionsPopup
	blood= $ScreenBlood
	weapon_info = $HUD/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/VBoxContainer2/WeaponInfo
	death_screen  = $DeathScreen
