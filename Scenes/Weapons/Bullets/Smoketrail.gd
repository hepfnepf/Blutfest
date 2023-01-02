extends Line2D


signal dead

export var wildness := 3.0

var lifetime := [1.0,2.0]
var tick_speed :=0.05
var tick := 0.0
export var wild_speed := 0.1
var point_age :=[0.0]
var age_factor :=5.0 #detemines how strong the trail gets blown out over time
export var min_spawn_distance := 5.0 #determines how close the points are together and how much the bullet has to move for a new point to get generated.
export var max_length := 50


onready var tween :=$Decay


var counter:int=0

func _ready():
	clear_points()
	connect("dead",get_parent(),"_on_trail_faded")
	set_as_toplevel(true)

func _process(delta):
	if tick > tick_speed:

		tick = 0
		var point_count = get_point_count()


		#if the trail gets to long the oldest point gets removed
		while point_count > max_length/min_spawn_distance:
			remove_point(0)
			point_age.erase(point_age[0])
			point_count -= 1

		#advancement of trail with the position of bullet
		for p in range (point_count):

			point_age[p] += delta*age_factor

			var rand_vector := Vector2(rand_range(-wild_speed, wild_speed),rand_range(-wild_speed, wild_speed))

			points[p] += rand_vector*wildness*point_age[p]

		counter+=1
	else:
		tick += delta


func add_point(point_pos:Vector2, at_po :=-1):#playe in space to be spawned at, position in the array to be spawned at
	if get_point_count() > 0 and point_pos.distance_to(points[get_point_count()-1]) < min_spawn_distance:#we only add a point if ther isn't alreay one very close by
		return
	point_age.append(0.0)
	.add_point(point_pos, at_po)


func fade_out(time=2.0):
	tween.interpolate_property(self,"modulate:a",1.0,0.0,time,Tween.TRANS_CIRC,Tween.EASE_OUT)
	tween.start()

func _on_Decay_tween_all_completed():
	emit_signal("dead")
	disable()

# ---------------- For Object Pooling --------------
#Gets called from parent
func reset():
	set_process(true)
	set_physics_process(true)
	clear_points()
	modulate.a = 1.0
	visible = true

func disable():
	visible = false
	set_process(false)
	set_physics_process(false)