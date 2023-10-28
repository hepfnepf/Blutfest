extends CanvasLayer

signal perk_selected

onready var health_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/HealthbarWidget
onready var exp_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/ExpbarWidget
onready var ammo_widget = $HUD/VBoxContainer/VBoxContainer/HBoxContainer/CenterContainer2/AmmoWidget
onready var score = $HUD/VBoxContainer/HBoxContainer3/ScoreWidget/Score
onready var time = $HUD/VBoxContainer/HBoxContainer3/TimeWidget/Time
onready var debug_info = $HUD/VBoxContainer/DebugLayout
onready var lock_texture = $HUD/VBoxContainer/HBoxContainer/LockSymbol
onready var crosshair = $Crosshair
onready var effect_container = $HUD/VBoxContainer/HBoxContainer/EffectContainer
onready var credits = $PauseMenu/CreditsScreen
onready var pause_menu =$PauseMenu
onready var card_holder = $CardHolder

var player:Player
var perkCard = preload("res://Scenes/UI/PerkSelection/PerkCard.tscn")


func _ready() -> void:
	pause_menu.set_debug_info(debug_info)
	#connect("perk_selected",PerkManager,"_on_Perk_selected")

func set_player(player:Player)->void:
	self.player = player

	set_health(player.health)
	set_max_health(player.max_health)
	set_score(player.score)
	reset_weapon(player.weapon.current_weapon)
	set_exp(player.experience)
	set_max_exp(player.experience_limit)

	player.weapon.connect("weapon_switch",self,"reset_weapon")
	player.perkManager.connect("newSelection",self,"_on_new_perk_selection")
	player.connect("health_changed",self,"set_health")
	player.connect("max_health_changed",self,"set_max_health")
	player.connect("exp_changed",self,"set_exp")
	player.connect("exp_limit_changed",self,"set_max_exp")
	player.connect("score_changed",self,"set_score")
	player.connect("dead",pause_menu,"_on_Player_Death")
	player.connect("time_changed",self,"set_time")
	player.connect("lock_changed",self,"set_lock")

func reset_weapon(weapon)->void:
	set_ammo(weapon.ammo)
	set_max_ammo(weapon.max_ammo)
	weapon.connect("ammo_changed",self,"set_ammo")
	weapon.connect("max_ammo_changed",self,"set_max_ammo")
	weapon.connect("reload_percent_change", self, "set_reload_progress")
	weapon.connect("spread_changed",crosshair,"set_spread")

func set_health(new_health:int)->void:
	health_widget.set_health(new_health)
func set_max_health(new_max_health:int)->void:
	health_widget.set_max_health(new_max_health)
func set_ammo(new_ammo:int)->void:
	ammo_widget.set_ammo(new_ammo)
func set_max_ammo(new_max_ammo:int)->void:
	ammo_widget.set_max_ammo(new_max_ammo)
func set_reload_progress(percent:float)->void:
	ammo_widget.set_reload_progress(percent)
func set_exp(new_exp:int)->void:
	exp_widget.set_exp(new_exp)
func set_max_exp(new_max_exp:int)->void:
	exp_widget.set_max_exp(new_max_exp)
func set_score(new_score:int)->void:
	score.text = str(new_score)
func set_time(new_time:int)->void:
	time.text = time_to_str(new_time)
func set_lock(new_lock:bool)->void:
	lock_texture.visible = new_lock
##Opens the perk selection screen
func _on_new_perk_selection(perks, raritys):
	get_tree().paused = true

	var cards = []
	for i in range(perks.size()):
		var card:PerkCard = perkCard.instance()
		card.perk=perks[i]
		card.rarity=raritys[i]
		cards.append(card)
		card.connect("card_selected",self,"_on_card_selected")

	for card in cards:
		card_holder.add_card(card)
	card_holder.visible=true
	card_holder.draw_cards()


	set_cursor(Globals.cursor_manager.CURSOR_TYPE.DEFAULT)

func _on_card_selected(card:PerkCard)->void:
	player.add_child(card.perk.instance())
	player.perkManager._on_Perk_selected(card.perk)
	card_holder.clear_cards(card)
	yield(card_holder,"cards_cleared")

	set_cursor(Globals.cursor_manager.CURSOR_TYPE.CROSSHAIR)
	get_tree().paused = false
	emit_signal("perk_selected")

func time_to_str(time:int) -> String:
# warning-ignore:integer_division
	var minutes = time / 60
	var seconds = time % 60
	var str_time = "%02d:%02d" % [minutes, seconds]
	return str_time

func set_cursor(cursor_type:int) -> void:
	Globals.cursor_manager.set_crosshair(crosshair)
	Globals.cursor_manager.set_cursor(cursor_type)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("show_debug_info"):
		debug_info.set_alive(!debug_info.alive)
