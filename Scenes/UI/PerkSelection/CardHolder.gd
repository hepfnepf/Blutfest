extends CenterContainer


func add_card(card:PerkCard)->void:
	$HBoxContainer.add_child(card)

func clear_cards()->void:
	for card in $HBoxContainer.get_children():
		card.queue_free()

func draw_animation()->void:

	pass
