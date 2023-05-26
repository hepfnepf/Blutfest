extends EffectBasis

var intervall:float = 1 # every x seconds
var spikeball=preload("res://Scenes/Weapons/Bullets/SpikedBall.tscn")
var damage:float = 65

onready var timer:Timer = $Timer

func _ready():
	timer.start(intervall)


func _on_Timer_timeout() -> void:
	timer.start(intervall)
	var bullet = BulletPool.get_bullet(spikeball,player.global_position)
	bullet.player=player
	bullet.direction = Vector2.ZERO
	bullet.speed = 0.1
	bullet.p_range = 2
	bullet.damage = damage*player.damage_multi
