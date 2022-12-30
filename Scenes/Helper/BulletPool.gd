extends Node2D

signal bullet_count_changed

var pools = {}

#Statistics
var bullets_active:int = 0
var bullets_cnt:int=0
"""
shoots an instance of the given bullet
"""
func get_bullet(packed_bullet:PackedScene, pos:Vector2 = Vector2(0,0)) -> Bullet:
	#Get bullet from correct pool
	var _bul:Bullet = null
	if packed_bullet in pools:
		_bul = pools[packed_bullet].pop()

		if _bul != null:
			#The position must be set before reset because the smoke trail uses its parent position when it gets reset
			_bul.position = pos			
			_bul.reset()
			
		else:
			_bul=create_new_bullet(packed_bullet,pos)
			
	else:
		pools[packed_bullet] = Queue.new()
		_bul= create_new_bullet(packed_bullet,pos)
	
	bullets_active +=1
	emit_signal("bullet_count_changed",bullets_cnt,bullets_active)
	return _bul

func create_new_bullet(packed_bullet:PackedScene, pos:Vector2) -> Bullet:
	var _bul = packed_bullet.instance()
	_bul.template = packed_bullet	
	_bul.global_position = pos
	add_child(_bul)
	bullets_cnt+=1
	emit_signal("bullet_count_changed",bullets_cnt,bullets_active)
	return _bul

func store_bullet(bullet:Bullet) -> void:
	if bullet.template == null:
		printerr("Bullet did not get its template set.")
		print(bullet)
	else:
		if bullet.template in pools:
			pools[bullet.template].add(bullet)
			bullet.disable()
		else:
			pools[bullet.template] = Queue.new()
			pools[bullet.template].add(bullet)
			bullet.disable() 
	bullets_active -=1
	emit_signal("bullet_count_changed",bullets_cnt,bullets_active)
