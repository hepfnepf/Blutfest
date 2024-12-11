extends PanelContainer


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

	if "projectile_nmbr" in weapon:
		dmg_label.text = "%.f x %d"%[dmg,weapon.projectile_nmbr]
	else:
		dmg_label.text = "%.f"%dmg
#	if is_instance_valid(weapon.Bullet):
#		dmg_type.text = str(weapon.Bullet.damage_type)
	fire_rate.text = "%.1f"%weapon.fire_rate
	range_label.text = str(int(weapon.max_range*weapon.player.range_multi))
	if weapon.explosion_damage == 0:
		exp_dmg.get_parent().visible=false
	else:
		exp_dmg.get_parent().visible=true
	exp_dmg.text = "%.f"%weapon.explosion_damage

