extends CenterContainer

signal cards_cleared

export(AudioStream)var sound_effect = null
export(float) var animation_duration = .5


func _ready() -> void:
	if animation_duration<sound_effect.get_length():
		printerr("Card drawing sound longer than animation")

func add_card(card:PerkCard)->void:
	$HBoxContainer.add_child(card)
	card.disabled = true

func clear_cards(selected_card:PerkCard)->void:
	var tween:SceneTreeTween  = create_tween()
	for card in $HBoxContainer.get_children():
		card.disabled = true



		if card != selected_card:
			if sound_effect:
				var audio_effect:AudioStreamPlayer = AudioStreamPlayer.new()
				card.add_child(audio_effect)
				audio_effect.stream = sound_effect
				#audio_effect.play()

				#TODO: this way, the sound gets timed, so it will always start at the time, that makes it complete with the animation
				#anim_dur = .5s, sfx= .37 --> animation starts parallel with the delay --> animation plays, after 0.13s sounds start, they finish at the same time
				#but if the sound is longer than the animation, it will play imidiatly and not be synced
				tween.tween_callback(audio_effect, "play").set_delay(max(animation_duration-sound_effect.get_length(),0))
				tween.parallel().tween_property(card,"rect_position",Vector2(card.rect_position.x,rect_size.y+card.rect_size.y),animation_duration)
			else:
				tween.tween_property(card,"rect_position",Vector2(card.rect_position.x,rect_size.y+card.rect_size.y),animation_duration)
			tween.tween_property(card,"rect_position",Vector2(card.rect_position.x,rect_size.y+card.rect_size.y),animation_duration)

	yield(tween,"finished")
	for card in $HBoxContainer.get_children():
		card.queue_free()

	yield(get_tree(), "idle_frame")#makes sure the cards are removed, so there are no conflicts if you level up mutltiple levels at once
	emit_signal("cards_cleared")

func draw_cards()->void:
	yield(get_tree(), "idle_frame")
	var tween:SceneTreeTween = create_tween()

	for card in $HBoxContainer.get_children():
		card.rect_position.y = rect_size.y+card.rect_size.y #move cards out of visible screen

	for card in $HBoxContainer.get_children():
		if sound_effect:
			var audio_effect:AudioStreamPlayer = AudioStreamPlayer.new()
			card.add_child(audio_effect)
			audio_effect.stream = sound_effect
			#audio_effect.play()

			#TODO: this way, the sound gets timed, so it will always start at the time, that makes it complete with the animation
			#anim_dur = .5s, sfx= .37 --> animation starts parallel with the delay --> animation plays, after 0.13s sounds start, they finish at the same time
			#but if the sound is longer than the animation, it will play imidiatly and not be synced
			tween.tween_callback(audio_effect, "play").set_delay(animation_duration-sound_effect.get_length())
			tween.parallel().tween_property(card,"rect_position",Vector2(card.rect_position.x,0),animation_duration)
		else:
			tween.tween_property(card,"rect_position",Vector2(card.rect_position.x,0),animation_duration)

	yield(tween,"finished")
	for card in $HBoxContainer.get_children():
		card.disabled = false
