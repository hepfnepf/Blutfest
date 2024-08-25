extends KinematicBody2D
class_name Player

signal dead
signal health_changed(new_health)
signal max_health_changed(new_max_health)
signal exp_changed(new_exp)
signal exp_limit_changed(new_exp_limit)
signal time_changed(new_time)
signal score_changed(new_score)
signal lock_changed(new_lock_state)
signal leveled_up

export (int) var move_speed_base = 300
export (int) var max_health = 100 setget set_max_health
export (int) var health = max_health setget set_health
export (PackedScene) var start_weapon = null
export (bool) var invincible:bool = false#for the invincibility item, exported for debugging
export (PackedScene) var explosion = null
export (float) var exp_damage = 100.0
export (float) var exp_size = 5.0

var experience:int = 0 setget set_experience
var experience_limit:int=100
var score:int = 0 setget set_score
var alive:bool = true
var elapsed_time=0 #get increased by 1 sec every time the time counter returns
var locked:bool = false #can the player pick up new guns
var damage_multi:float=1.0#will mosty influenced by perks
var dmg_multi_not_moving:float=1.0 #will be influenced only by increased damage while not moving perk
var level:int=1
var weapon_movement_speed_multi:float = 1.0 setget set_weapon_movement_speed_multi
var move_speed:float = move_speed_base#gets recalced in ready

#For statistics and some percs
var enemies_hit:int = 0 setget set_enemies_hit
var shots_fired:int = 0 setget set_shots_fired
var accuracy:float = 0
var health_gained:int=0
var health_lost:int=0
var enemies_killed:int=0
var distance_covered:float=0
var powerups_collected_amnt:int=0
#var perks_collected_amnt:int=0 can be gotten from PerkManager.active_perks.length
var damage_caused:int=0 setget set_damage_caused
var max_standing_time:float=0
var current_standing_time:float=0
#var weapon_time_used={} can be gotten from weapon.weapon_time_used
var power_ups_collected={}
var explosion_amnt:int=0 setget set_explosion_amnt


#For effects and perks

#How much of the current value is due to temporary effects
var delta_move_speed:float = 0
var invincible_count:int = 0
var debug_invincible:bool=false
var bullet_time_count:int = 0

# For Perks
var heal_up_on_level_up:int = 0
var explosion_on_level_up:bool = false
var spike_balls_explode:bool = false
var spike_ball_explosion_damage:float = 90.0
var boost_accuracy_dmg_level:int = 0 setget set_boost_accuracy_dmg_level
var cap_accuracy:bool = true
var shaky_finger:bool = false
var tit_for_tat_good_multi:float = 1.0 # the longterm increase in deamage dealt
var tit_for_tat_bad_multi:float=1.0 setget set_tit_for_tat_bad_multi# the shortterm multiplier on damage recieved
var items_explode:bool=false
var vampire_percent:float=0.0
var explosion_amt_size_multi:float=1.0
var explosion_amt_size_multi_inc:float=0.0
var max_explosion_amt_size_multi:float=1.0
var see_hpbars:bool=false
var hp_increase_increases_maxhp_lvl:int=0
var manuel_reloading_perk:float=0.0#how much of the reload will be taken away in percent from 0 to 1
var lazy_reloading:bool = false
var regeneration_perk:bool = true
var seconds_to_start_regeneration:float = 30.0
var regeneration_amt:float = 1.0 #hp per second
var spike_balls_explode_on_death:bool=false
var medic_multiplier:float = 1.0
var ice_damage:int = 0
var ice_damage_mult:float = 1.0
var thorn_damage:int = 0
var thorn_damage_equal_fac:float = 0.0
var range_multi:float = 1.0

onready var weapon = $Weapon
onready var hurt:AudioStreamPlayer = $Hurt
onready var perkManager:PerkManager = $PerkManager
onready var regenerationTimer:Timer = $RegenerationTimer
onready var camera:Camera2D = $Camera2D
onready var gui = get_node_or_null("/root/Game/GUI")
onready var shockWave=get_node_or_null("/root/Game/ShockWaveLayer/ShockWave")

#Movement
var velocity:Vector2 = Vector2.ZERO #needed for movement inaccuracy of player
export (float) var friction = 0.01
export (float) var acceleration = 0.1
var is_standing:bool = true #used for perks and statistics

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	if start_weapon != null:
		weapon.set_weapon(start_weapon)
	regenerationTimer.wait_time = seconds_to_start_regeneration
	calculate_move_speed()

func _physics_process(delta)->void:
	if !alive:
		return

	#Check if the lock-state has to be changed
	if Input.is_action_just_pressed("lock_weapon"):
		locked = !locked
		emit_signal("lock_changed",locked)

	if Input.is_action_just_pressed("toggle_debug_invincibility") and  OS.is_debug_build():
		debug_invincible=!debug_invincible
	#Movement
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -=1
	if Input.is_action_pressed("move_down"):
		move_vec.y +=1
	if Input.is_action_pressed("move_left"):
		move_vec.x -=1
	if Input.is_action_pressed("move_right"):
		move_vec.x +=1

	move_vec = move_vec.normalized()
	#animateWalk(move_vec)
	#velocity = move_vec.length() * move_speed
	if move_vec.length() > 0:
		velocity = lerp(velocity, move_vec * move_speed,acceleration)
	else:
		velocity = lerp(velocity, Vector2.ZERO,friction)

	move_and_collide(velocity * delta)
	distance_covered+=velocity.length()*delta#for statistics
	# = 0 has a ~5 second delay until "is_standing" is set to true
	# <= 0.1 reduces the delay where "is_standing" will be set to true to ~1 second
	if velocity.length() <= 0.1:
		#used for statistics
		if is_standing==false:
			current_standing_time=0
		else:
			current_standing_time+=delta

		is_standing=true
	else:
		#for statistics
		if is_standing==true:
			if current_standing_time>max_standing_time:
				max_standing_time=current_standing_time
			current_standing_time=0

		is_standing=false

	#self.look_at(get_global_mouse_position()-self.position)
	look_at(get_global_mouse_position())

#Health related, maybe should be outsourced to its own node
func set_health(new_health:int)->void:
	if !alive:
		return

	var _health_before:int=health #used for statistics

	if new_health > max_health:
		if hp_increase_increases_maxhp_lvl == 1 and health==max_health:#perk PerkIncreaseMaxHealth
			health=max_health
			set_max_health(max_health+floor((new_health-max_health)/2.0))
		elif hp_increase_increases_maxhp_lvl == 2:
			set_max_health(max_health+floor((new_health-max_health)/2.0))
			health=max_health
		else:
			health=max_health
	else:
		health_lost += clamp(health-new_health,0,health)
		health = new_health

	if health>_health_before:
		health_gained+=health-_health_before#used for statistics

	emit_signal("health_changed",health)
	if health <= 0:
		die()

func set_max_health(new_max_health:int)->void:
	if !alive:
		return
	max_health = new_max_health
	emit_signal("max_health_changed",max_health)

func add_points(points:int)->void:
	set_score(score+points)
	set_experience(experience+points)

func set_score(new_score)->void:
	if !alive:
		return
	score=new_score
	emit_signal("score_changed",new_score)

func set_enemies_hit(new_amnt)->void:
	enemies_hit = new_amnt
	calculate_accuracy()

func set_damage_caused(new_damage)->void:
	if vampire_percent > 0.0:
		set_health(health+int(ceil(vampire_percent/100.0*(new_damage-damage_caused))))#for vampire perk
	damage_caused=new_damage

func set_explosion_amnt(new_amt)->void:
	explosion_amnt+=1
	explosion_amt_size_multi= clamp(explosion_amt_size_multi+explosion_amt_size_multi_inc,1.0,max_explosion_amt_size_multi)

func set_shots_fired(new_amnt)->void:
	shots_fired = new_amnt
	calculate_accuracy()

func calculate_accuracy()->void:
	#you could never reache 100%, because shots_fired is always at least 1 bigger than enemies hit, therefore we reduce that by one
	var _shots_fired_modi=1
	if (shots_fired==1):
		accuracy = 1.0
		calculate_damage_multiplier()
		return

	if(cap_accuracy):
			accuracy = clamp(float(enemies_hit)/float(shots_fired-_shots_fired_modi),0.0,1.0)
	else:
		accuracy = float(enemies_hit)/float(shots_fired-_shots_fired_modi)
	calculate_damage_multiplier()

func set_boost_accuracy_dmg_level(level)->void:
	boost_accuracy_dmg_level=level
	calculate_damage_multiplier()

func set_tit_for_tat_bad_multi(new_multi)->void:
	tit_for_tat_bad_multi=new_multi
	calculate_damage_multiplier()

func calculate_damage_multiplier()->void:

	var accuracy_boni = 1.0
	var not_moving_bonus = 1.0
	if(boost_accuracy_dmg_level==1):
		accuracy_boni = 2.0*accuracy
	elif(boost_accuracy_dmg_level==2):
		if(accuracy>=1.0):
			accuracy_boni = 2.0*accuracy
		elif(accuracy>=0.7):
			accuracy_boni = 2
		else:
			accuracy_boni=accuracy

	if(is_standing == true):
		not_moving_bonus = dmg_multi_not_moving

	damage_multi = 1.0 * accuracy_boni * tit_for_tat_good_multi * not_moving_bonus

func add_enemy_death()->void:
	enemies_killed+=1

func set_weapon_movement_speed_multi(new_speed_multi)->void:
	weapon_movement_speed_multi=new_speed_multi
	calculate_move_speed()

func calculate_move_speed()->void:
	move_speed = move_speed_base * weapon_movement_speed_multi

func die()->void:
	emit_signal("dead")
	alive = false

func take_damage(damage:int,entity=null)->void:
	if !alive or invincible or debug_invincible:
		return

	damage=damage*tit_for_tat_bad_multi

	if shaky_finger:
		set_health(health - damage * accuracy)
	else:
		set_health(health - damage)
	hurt.play()

	if regeneration_perk:
		regenerationTimer.start(seconds_to_start_regeneration)

	if entity:
		if entity.has_method("handle_hit"):
			if thorn_damage_equal_fac:
				entity.handle_hit(thorn_damage_equal_fac*damage)
			entity.handle_hit(thorn_damage)

#Experience Management
func set_experience(new_exp:int)->void:
	if !alive:
		return
	experience = new_exp
	emit_signal("exp_changed",experience)
	while experience >= experience_limit:
		level_up()
		#important so that the perk selection does not get called multiple time before a single perk gets selected
		if is_instance_valid(gui):
			yield(gui, "perk_selected")

func level_up():
	if !alive:
		return
	experience -= experience_limit
	level+=1
	print("Level UP")
	emit_signal("leveled_up")

	$LevelUpSound.play()

	if is_instance_valid(shockWave):
		shockWave.start(1.0)
		yield(shockWave,"wave_finished")#removing this line will make the wave appear after perk card selection

	if heal_up_on_level_up:
		set_health(health+heal_up_on_level_up)
	if explosion_on_level_up:
		create_explosion(exp_damage,exp_size)

	perkManager.new_perk_selection()
	emit_signal("exp_changed",experience)
	next_exp_limit()

func next_exp_limit():
	if !alive:
		return
	experience_limit = experience_limit*2
	emit_signal("exp_limit_changed",experience_limit)
	pass

func change_invincibility(change:int):#function to be used from effect to turn the player invincible, it handles stacking of the effect
	invincible_count += change
	if invincible_count <= 0:
		invincible = false
		invincible_count = 0
	else:
		invincible = true

func create_explosion(damage,size,pos=null):
	var _exp = explosion.instance()
	_exp.global_position=global_position
	if pos:
		_exp.global_position=pos
	_exp.damage = damage
	_exp.scale =Vector2(size,size)*explosion_amt_size_multi
	var game = get_node_or_null("/root/Game")#gets set again, because if game gets reset after player death, this instance will be removed
	if game!=null:
		set_explosion_amnt(explosion_amnt+1)
		game.call_deferred("add_child", _exp)

func set_weapon(_weapon):
	if !alive:
		return
	weapon.set_weapon(_weapon)

#gets called from the item on pickup
func stats_add_powerup(powerup)->void:
	if power_ups_collected.has(powerup):
		power_ups_collected[powerup]+=1
	else:
		power_ups_collected[powerup]=1

func _on_Area2D_area_entered(area):
	if !alive:
		return

	if area.is_in_group("Item"):
		if area.has_method("pick_up"):
			if !locked or !area.is_in_group("WeaponItem"):
				area.pick_up(self)
		else:
			print("Item without pickup function")


func _on_ElapsedTime_timeout():
	if !alive:
		return
	elapsed_time += 1
	emit_signal("time_changed",elapsed_time)

func _on_regeneration_step()->void:
	set_health(health+regeneration_amt)

func _on_RegenerationTimer_timeout() -> void:
	_on_regeneration_step()
	regenerationTimer.start(1.0)
