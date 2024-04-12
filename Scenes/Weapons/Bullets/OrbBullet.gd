extends Bullet


export(float)var min_wobble_volume=0.0
export(float)var max_wobble_volume=0.0


var charge_amt:float=0.0 setget set_charge_amt #0 to 1 of max charge

onready var wobble_sound:AudioStreamPlayer2D=$WobbleSound
func _ready() -> void:
	._ready()
	sprite = $Orb



func _on_Bullet_body_entered(body):
	if !alive or body.is_in_group("Projectile"):
		return
	#die()

	if body.has_method("handle_hit"):
		damage = damage - body.handle_hit(damage, Globals.DamageType.PROJECTILE)
		if (is_instance_valid(player) and direct):
			player.enemies_hit +=1
	if exp_dmg != 0.0 and !body.is_in_group("Border"):
		explode()
	if damage <1:
		die()

func set_charge_amt(new_amt)->void:
	charge_amt=new_amt
	wobble_sound.volume_db= linear2db(charge_amt*5)#min_wobble_volume + charge_amt* (max_wobble_volume-min_wobble_volume)


func die():
	if alive:
		alive = false
		BulletPool.store_bullet(self) # calls disable() on bullet


func reset():
	.reset()
	wobble_sound.play()



func disable():
	.disable()
	wobble_sound.stop()
