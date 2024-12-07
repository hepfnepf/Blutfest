extends VBoxContainer


onready var name_label := $"%WeaponName"
onready var dmg_label := $"%Damage"
onready var dmg_type :=  $"%DamageType"
onready var fire_rate :=  $"%Rate"
onready var range_label := $"%Range"
onready var exp_dmg := $"%ExplosionDamage"

func set_attributes(weapon:Weapon)->void:
	name_label.text = str(weapon.gun_name)

	var dmg = weapon.damage
	if "damage_boost" in weapon:#eg pistol
		dmg+=weapon.damage_boost
	dmg *= weapon.player.damage_multi
	dmg_label.text = str(dmg)
#	if is_instance_valid(weapon.Bullet):
#		dmg_type.text = str(weapon.Bullet.damage_type)
	fire_rate.text = str(weapon.fire_rate)
	range_label.text = str(weapon.max_range)
	if weapon.explosion_damage == 0:
		exp_dmg.get_parent().visible=false
	else:
		exp_dmg.get_parent().visible=true
	exp_dmg.text = str(weapon.explosion_damage)

