extends Tabs

signal changed_sound

onready var hs_reset_announcement = $"%HighscoreResetAnnouncement"
onready var hs_reset_announcement_time = $MarginContainer/VBoxContainer/HighscoreResetAnnouncement/Timer
onready var op_reset_announcement = $"%OptionsResetAnnouncement"
onready var op_reset_announcement_timer = $MarginContainer/VBoxContainer/OptionsResetAnnouncement/Timer

onready var max_enemy_count_slider:Slider = $"%EnemyCountSlider"
onready var slider_min = $"%SliderMin"
onready var slider_max = $"%SliderMax"
onready var max_enemy_count = $MarginContainer/VBoxContainer/MaxEnemyCount

func _ready() -> void:
	slider_min.text = str(max_enemy_count_slider.min_value)
	slider_max.text = str(max_enemy_count_slider.max_value)

func set_enemy_count_label(count:int)->void:
	max_enemy_count.text = tr("MAX_ENEMY_COUNT")%count


func _on_ResetHighscore_pressed()->void:
	SaveManager.set_game_save(SaveManager.new_save_game_dict)

	hs_reset_announcement.show()
	hs_reset_announcement_time.start()

func _on_ResetOptions_pressed() -> void:
	SaveManager.set_options_save(SaveManager.new_save_options_dict)
	SaveManager.reset_key_bindings()
	SaveManager.init_game()

	op_reset_announcement.show()
	op_reset_announcement_timer.start()

	EventBus.emit_signal("settings_reset")
	emit_signal("changed_sound")

func _on_Timer_timeout_hs() -> void:
	hs_reset_announcement.hide()


func _on_Timer_timeout_op() -> void:
	op_reset_announcement.hide()


func _on_EnemyCounSlider_value_changed(value: int) -> void:
	EventBus.emit_signal("max_enemy_count_change",value)
	set_enemy_count_label(value)
