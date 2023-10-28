extends CenterContainer

signal cards_cleared

export(float) var animation_duration = .5

func add_card(card:PerkCard)->void:
	$HBoxContainer.add_child(card)
	card.disabled = true

func clear_cards(selected_card:PerkCard)->void:
	var tween:SceneTreeTween  = create_tween()
	for card in $HBoxContainer.get_children():
		card.disabled = true
		if card != selected_card:
			tween.tween_property(card,"rect_position",Vector2(card.rect_position.x,rect_size.y+card.rect_size.y),animation_duration)

	yield(tween,"finished")
	for card in $HBoxContainer.get_children():
		card.queue_free()
	emit_signal("cards_cleared")

func draw_cards()->void:
	yield(get_tree(), "idle_frame")
	var tween:SceneTreeTween = create_tween()

	for card in $HBoxContainer.get_children():
		card.rect_position.y = rect_size.y+card.rect_size.y #move cards out of visible screen

	for card in $HBoxContainer.get_children():
		tween.tween_property(card,"rect_position",Vector2(card.rect_position.x,0),animation_duration)

	yield(tween,"finished")
	for card in $HBoxContainer.get_children():
		card.disabled = false
