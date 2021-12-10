class_name Queue

var queue = []
# Called when the node enters the scene tree for the first time.
func _init():
	pass

func is_empty():
	return queue.empty()

func add(element):
	queue.append(element)

func pop():
	return queue.pop_front()
func _to_string():
	return str(queue)
