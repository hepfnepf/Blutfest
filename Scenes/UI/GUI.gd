extends CanvasLayer

onready var health_widget = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/HealthbarWidget
onready var exp_widget = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/VBoxContainer/ExpbarWidget
onready var ammo_widget = $MarginContainer/VBoxContainer/HBoxContainer/CenterContainer2/AmmoWidget
onready var score = $MarginContainer/VBoxContainer/HBoxContainer3/HBoxContainer2/Score
onready var debug_info = $MarginContainer/VBoxContainer/HBoxContainer3/DebugLayout
onready var crosshair = $Crosshair

#enum CURSOR_TYPE{DEFAULT,CUSTOM}
var player:Player

func set_player(player):
	self.player = player
	
	set_health(player.health)
	set_max_health(player.max_health)
	set_score(player.score)
	reset_weapon(player.Weapon.current_weapon)
	set_exp(player.experience)
	set_max_exp(player.experience_limit)
	
	player.Weapon.connect("weapon_switch",self,"reset_weapon")
	player.connect("health_changed",self,"set_health")
	player.connect("max_health_changed",self,"set_max_health")
	player.connect("exp_changed",self,"set_exp")
	player.connect("exp_limit_changed",self,"set_max_exp")
	player.connect("score_changed",self,"set_score")

func reset_weapon(weapon):
	set_ammo(weapon.ammo)
	set_max_ammo(weapon.max_ammo)
	weapon.connect("ammo_changed",self,"set_ammo")
	weapon.connect("max_ammo_changed",self,"set_max_ammo")
	weapon.connect("reload_percent_change", self, "set_reload_progress")
	weapon.connect("spread_changed",crosshair,"set_spread")

func set_health(new_health):
	health_widget.set_health(new_health)
func set_max_health(new_max_health):
	health_widget.set_max_health(new_max_health)
func set_ammo(new_ammo):
	ammo_widget.set_ammo(new_ammo)
func set_max_ammo(new_max_ammo):
	ammo_widget.set_max_ammo(new_max_ammo)
func set_reload_progress(percent):
	ammo_widget.set_reload_progress(percent)
func set_exp(new_exp):
	exp_widget.set_exp(new_exp)
func set_max_exp(new_max_exp):
	exp_widget.set_max_exp(new_max_exp)
func set_score(new_score):
	score.text = str(new_score)

func set_cursor(cursor_type:int) -> void:
	if cursor_type == Globals.CURSOR_TYPE.CUSTOM:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		crosshair.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		crosshair.visible = false

#func _input(event):
#	if event.is_action_just_pressed("show_debug_info"):
#		debug_info.is_visible_in_tree(!debug_info.is_visible_in_tree())

func _unhandled_input(event):
	if Input.is_action_just_pressed("show_debug_info"):
		debug_info.set_alive(!debug_info.alive)
