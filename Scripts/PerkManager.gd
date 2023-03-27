extends Node
class_name PerkManager

signal newSelection


#The two variables describe the perks and likeliehoods only during initialisation
#Ones have to consider, that despite a perk being added to perks and having a likeliehood, it may not appear in the current_perks array
#if its requirements are not satisfied. A perks requirements are defined in the perks script.
export(Array,PackedScene) var perks=[]
export(Array,float) var base_likelihoods=[]
#I decided to store the likeliehoods in an extra array instead of in each perks packed scene
#this was done because	1. This allows to see and manipulate all likeliehoods from a central point
#						2. The likeliehoods are not needed somwhere else

export(Dictionary) var perks_likeliehoods={}

var current_perks:Array = []
var current_likelihoods:Array=[]
var active_perks:Array=[]
var blocked_perks:Array=[] #cant be chosen anymore
var perk_probs:Array = [] #Gets calculated from item_likelihood. Actual probability.

var perk_selection_amount:int=2

func _ready()->void:
	assert(perks.size()==base_likelihoods.size(),"Different amount of perks and likelihoods")
	update_current_arrays() #creates current_perks and _likeliehoods
	perk_probs=compute_percentages(current_perks,current_likelihoods)
	print_debug("TODO:change current lh tu just lh\nuse dict\ndocument")

func new_perk_selection()->void:
	var perk_candidates:Array=[]

	#Get perk candidates
	var temp_perks=[]+(current_perks)
	var temp_lh=[]+(current_likelihoods)
	for _i in range(perk_selection_amount):
		#select perk
		var perk = get_random_perk(temp_perks,compute_percentages(temp_perks,temp_lh))
		perk_candidates.append(perk)
		#remove that perk from the possibilities
		var index = temp_perks.find(perk)
		temp_perks.remove(index)
		temp_lh.remove(index)

	#Send to GUI
	emit_signal("newSelection",perk_candidates)

##Creates the run time arrays from the exported base arrays
func update_current_arrays() -> void:

	var temp_perks=[]
	var temp_likeliehoods=[]


	var changed:bool = true
	while changed:
		changed = false
		for i in range(perks.size()):
			if !(perks[i] in temp_perks) and !(perks[i] in blocked_perks) and requirements_satisfied(perks[i],active_perks):
				temp_perks.append(perks[i])
				temp_likeliehoods.append(base_likelihoods[i])
				changed=true
	current_perks=temp_perks
	current_likelihoods=temp_likeliehoods

# A perk may require certain perks to be activated
func requirements_satisfied(perk:PackedScene, active_perks:Array) -> bool:
	#TODO implement
	var state:SceneState=perk.get_state()
	var required_perks=[]

	var prop_count:int = state.get_node_property_count(0)
	for i in range(prop_count):
		if state.get_node_property_name(0,i)=="required":
			required_perks=state.get_node_property_value(0,i)

	for req_perk in required_perks:
		if !(req_perk in active_perks):
			return false

	return true

func _on_Perk_selected(perk:PackedScene) -> void:
	#Add to active perks
	active_perks.append(perk)

	#Remove now blocked perks
	var _blocked_perks=[]
	var state:SceneState=perk.get_state()
	var prop_count:int = state.get_node_property_count(0)
	for i in range(prop_count):
		if state.get_node_property_name(0,i)=="blocked":
			_blocked_perks=state.get_node_property_value(0,i)
	for perk in _blocked_perks:
		blocked_perks.append(perk)
		remove_perk(perk)
	update_current_arrays()
	compute_percentages()

func remove_perk(perk, perks_array=self.current_perks,likelihood_array=self.current_likelihoods) -> void:
	var ind:int = current_perks.find(perk)
	current_perks.remove(ind)
	current_likelihoods.remove(ind)

func get_random_perk(perks=self.current_perks,probs=self.perk_probs) -> PackedScene:
	if probs == []:
		compute_percentages()
	var _perk = perks[probs.bsearch(randf())]
	return _perk

func compute_percentages(perks=self.current_perks,likelihoods=self.current_likelihoods)->Array:
	var start:float = 0
	if perks.size() != likelihoods.size():
		print_debug("ERROR: AMOUNT OF LIKELIHOODS DOES NOT EQUAL AMOUNT OF ITEMS IN SPAWNER")


	var new_perk_probs:Array=[]
	var total:float = float(sum(likelihoods))

	for perks in likelihoods:
		var prob:float =float(perks)/total
		new_perk_probs.append(start + prob)
		start +=prob

	return new_perk_probs

func sum(int_array:Array)-> int:
	var res:int = 0
	for el in int_array:
		res += el
	return res
