extends Node

# warning-ignore-all:UNUSED_SIGNAL
signal zooming_inverted(zooming_inv)
signal blood_overlay_enabled(enabled)
signal hide_crosshair(hidden)
signal crosshair_type_changed(new_type)
signal crosshair_is_dynamic(is_dynamic)
signal cone_crosshair_is_dynamic(is_dynamic)
signal crosshair_color_change(new_color)
signal cone_crosshair_change(new_color)
signal crosshair_size_change(new_size)
signal cone_crosshair_size_change(new_size)
signal max_enemy_count_change(new_count)#gets emitted in the settings menu, connected to the spawner
signal settings_reset()
signal fullscreen_changed()
signal vsync_changed()
signal weapon_dmg_changed()
signal weapon_rate_changed()
signal weapon_range_changed()
