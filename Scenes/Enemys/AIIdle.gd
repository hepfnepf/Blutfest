extends Node2D

export var patrol_range:float = 50


var movementNode:Movement = null


var alive:bool=true

var patrol_destination:Vector2 = Vector2()


func initialize(movementNode:Movement)->void:
	self.movementNode = movementNode
	movementNode.connect("reached_destination",self,"_on_reached_destination")
	patrol_destination = create_random_patrol_location()
	movementNode.set_destination(patrol_destination)


func _process(_delta)->void:
	movementNode.set_destination(patrol_destination)


func create_random_patrol_location() -> Vector2:
	var min_range = 0
	var random_x=rand_range(-(patrol_range-min_range), (patrol_range-min_range))#allways returns same numbers, if seed isnt changed at each playtrough with randomize()
	var random_y=rand_range(-(patrol_range-min_range), (patrol_range-min_range))
	var origin = get_parent().get_parent().global_position
	return Vector2(random_x, random_y)+ origin+Vector2(min_range,min_range)

func _on_reached_destination()->void:
	patrol_destination = create_random_patrol_location()

