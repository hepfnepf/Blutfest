extends Node
class_name PerkManager
##
## This Script handles the selection and distribution of perks.
##
## @desc:
##     This script manages the perks. It generates the set of selectable perks based on the requirements stored in the perk scenens.
##     And it generates the propability of each perk and creates the selection the player has when leveling up. It sends those perks
##     to the GUI, which wraps then in cards. The gui has a reference to this perk manager and informs it which perk was selected.
## @tutorial:***
##
##

signal newSelection(perk,rarity)


#The two variables describe the perks and likeliehoods only during initialisation
#Ones have to consider, that despite a perk being added to perks and having a likeliehood, it may not appear in the current_perks array
#if its requirements are not satisfied. A perks requirements are defined in the perks script.
export(Array,PackedScene) var perks=[]
export(Array,float) var likelihoods=[]
#I decided to store the likeliehoods in an extra array instead of in each perks packed scene
#this was done because	1. This allows to see and manipulate all likeliehoods from a central point
#						2. The likeliehoods are not needed somwhere else

#Steps of the raritys
#perk p will have the rarity level x, if p's likeliehood is smaller than the rarity_x but higher than all other raritys
#This means the exported rarity values need to get lower with higher raritys. If the lh is higher then rarity_normal, the rarity will be COMMON
enum RARITY{COMMON,NORMAL,RARE,LEGENDARY}#export(float) var rarity_common
export(float) var rarity_normal
export(float) var rarity_rare
export(float) var rarity_legendary

var current_perks:Array = []
var current_likelihoods:Array=[]
var active_perks:Array=[]
var blocked_perks:Array=[] #resource_path of perks, that cant be chosen anymore
var perk_probs:Array = [] #Gets calculated from item_likelihood. Actual probability.

export(int)var perk_selection_amount=2

func _ready()->void:
	assert(perks.size()==likelihoods.size(),"Different amount of perks and likelihoods")
	assert(rarity_normal>rarity_rare and rarity_rare>rarity_legendary,"Exported rarity steppings are not increasing.")
	update_current_arrays() #creates current_perks and _likeliehoods
	update_probs()
	#print_debug(perk_name_from_scene(current_perks[0]))

## Draws perk_selection_amount perks of the currently available ones
func new_perk_selection()->void:
	var perk_candidates:Array=[]
	var candidates_rarity:Array=[]

	#Get perk candidates
	var temp_perks=[]+(current_perks)
	var temp_lh=[]+(current_likelihoods)
	for _i in range(perk_selection_amount):
		#select perk
		var perk = get_random_perk(temp_perks,compute_percentages(temp_perks,temp_lh))
		perk_candidates.append(perk)
		candidates_rarity.append(get_rarity(current_likelihoods[current_perks.find(perk)]))
		#candidates_rarity.append(perk_probs[current_perks.find(perk)])
		#remove that perk from the possibilities
		var index = temp_perks.find(perk)
		temp_perks.remove(index)
		temp_lh.remove(index)

	#Send to GUI
	emit_signal("newSelection",perk_candidates, candidates_rarity)

##Creates the run time arrays of current perks and likeliehoods from the exported base arrays, by checking the perks requirements and blocks
func update_current_arrays() -> void:
	var temp_perks=[]
	var temp_likeliehoods=[]

	#Since some perks effect the possiblity to get other perks, (requirements), this is a topoligical sorting problem
	#https://en.wikipedia.org/wiki/Topological_sorting
	#This is a very naive approch, always adding perks ready to be accepted and than go through all perks to see if any new ones
	#are available now
	var changed:bool = true
	while changed:
		changed = false
		for i in range(perks.size()):
			if !(perks[i] in temp_perks) and !(perks[i].resource_path in blocked_perks) and requirements_satisfied(perks[i],active_perks):
				temp_perks.append(perks[i])
				temp_likeliehoods.append(likelihoods[i])
				changed=true
	current_perks=temp_perks
	current_likelihoods=temp_likeliehoods

## A perk may require certain perks to be activated to be available
func requirements_satisfied(perk:PackedScene, active_perks:Array) -> bool:
	var state:SceneState=perk.get_state()
	var required_perks:Array=[]
	var min_level:int=0

	var prop_count:int = state.get_node_property_count(0)
	for i in range(prop_count):
		if state.get_node_property_name(0,i)=="required":
			required_perks=state.get_node_property_value(0,i)
		if state.get_node_property_name(0,i)=="min_level":
			min_level=state.get_node_property_value(0,i)

	for req_perk in required_perks:
		if !(req_perk in active_perks):
			return false

	if get_parent().level < min_level:
		return false

	return true

func get_rarity(likeliehood:float)-> int:
	if likeliehood <= rarity_legendary:
		return Globals.Rarity.LEGENDARY
	if likeliehood <= rarity_rare:
		return Globals.Rarity.RARE
	if likeliehood <= rarity_normal:
		return Globals.Rarity.NORMAL
	else:
		return Globals.Rarity.COMMON

#Gets called from GUI
func _on_Perk_selected(perk:PackedScene) -> void:
	#Add to active perks
	active_perks.append(perk)

	#Remove now blocked perks
	var _blocked_perks=[]
	var state:SceneState=perk.get_state()
	var prop_count:int = state.get_node_property_count(0)
	for i in range(prop_count):
		if state.get_node_property_name(0,i)=="blocks":
			_blocked_perks.append_array(state.get_node_property_value(0,i))
		if state.get_node_property_name(0,i)=="one_time":
			_blocked_perks.append(perk.resource_path)
	for perk in _blocked_perks:
		blocked_perks.append(perk.resource_path)
		remove_perk(perk)
	#Update arrays
	update_current_arrays()
	update_probs()

func remove_perk(perk, perks_array=self.current_perks,likelihood_array=self.current_likelihoods) -> void:
	var ind:int = current_perks.find(perk)
	current_perks.remove(ind)
	current_likelihoods.remove(ind)

func get_random_perk(perks=self.current_perks,probs=self.perk_probs) -> PackedScene:
	if probs == []:
		update_probs()
	var _perk = perks[probs.bsearch(randf())]
	return _perk

func update_probs()->void:
	perk_probs=compute_percentages(self.current_perks,self.current_likelihoods)

func compute_percentages(perks,likelihoods)->Array:
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
