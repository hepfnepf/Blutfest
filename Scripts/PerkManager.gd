extends Node
class_name PerkManager

signal newSelection

export(Array,PackedScene) var perks=null
export(Array,float) var likelihoods=null
var perk_probs:Array = [] #Gets calculated from item_likelihood. Actual probability.

var perk_selection_amount:int=2

func _ready()->void:
	assert(perks.size()==likelihoods.size(),"Different amount of perks and likelihoods")
	perk_probs=compute_percentages()

func new_perk_selection()->void:
	var perk_candidates:Array=[]
	
	#Get perk candidates
	var temp_perks=[]+(perks)
	var temp_lh=[]+(likelihoods)
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

func get_random_perk(perks=self.perks,probs=self.perk_probs):
	if probs == []:
		compute_percentages()
	var _perk = perks[probs.bsearch(randf())]
	return _perk

func compute_percentages(perks=self.perks,likelihoods=self.likelihoods)->Array:
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
