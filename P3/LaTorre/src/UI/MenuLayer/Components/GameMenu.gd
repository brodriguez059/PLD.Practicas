extends Control
class_name GameMenu

# warning-ignore:unused_signal
signal next_menu_accessed(menu_name)
# warning-ignore:unused_signal
signal prev_menu_accessed(menu_name)
# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal game_started()
# warning-ignore:unused_signal
signal game_exited()
# warning-ignore:unused_signal
signal button_fx_played()

export (String) var next_menu = ""
export (String) var prev_menu = ""
export (String) var music_name = ""
