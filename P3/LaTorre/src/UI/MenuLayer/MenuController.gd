extends CanvasLayer

# Signals
# warning-ignore:unused_signal
signal music_changed(music_stream)
# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal game_started()
# warning-ignore:unused_signal
signal game_finished(win)
# warning-ignore:unused_signal
signal game_exited()

# Constants
const menu_path : String = "res://src/UI/MenuLayer/Menus/"

# Exported variables
export(String) var initial_menu = ""

# State variables
var current_menu = null

# Node variables
onready var button_stream = $ButtonFx

func _ready() -> void:
	current_menu = $Menu
	if initial_menu != "":
		# Remove the menu
		self.remove_child(current_menu)
		current_menu.call_deferred("free")
		# Instantiate and add the new menu
		var path = menu_path + initial_menu + ".tscn"
		var level_resource = load(path)
		current_menu = level_resource.instance()

	current_menu.connect("next_menu_accessed", self, "_on_menu_accessed")
	current_menu.connect("prev_menu_accessed", self, "_on_menu_accessed")
	current_menu.connect("configuration_toggled", self, "_on_configuration_toggled")
	current_menu.connect("game_exited", self, "_on_game_exited")
	current_menu.connect("game_started", self, "_on_game_started")
	current_menu.connect("button_fx_played", self, "_on_button_fx_played")
	emit_signal("music_changed", current_menu.music_name)

# Auxiliary functions
func play_button_sound() -> void:
	button_stream.stop()
	button_stream.play()

func prepare_menu(menu_name : String):
	var path = menu_path + menu_name + ".tscn"
	var level_resource = load(path)
	var level_instance = level_resource.instance()

	level_instance.connect("next_menu_accessed", self, "_on_menu_accessed")
	level_instance.connect("prev_menu_accessed", self, "_on_menu_accessed")
	level_instance.connect("configuration_toggled", self, "_on_configuration_toggled")
	level_instance.connect("game_exited", self, "_on_game_exited")
	level_instance.connect("game_started", self, "_on_game_started")
	level_instance.connect("button_fx_played", self, "_on_button_fx_played")
	return level_instance

# UI signal handlers
func _on_button_fx_played() -> void:
	play_button_sound()

# Next menu + Prev menu
func _on_menu_accessed(menu_name) -> void:
	# Remove the menu
	var menu = self.get_child(0)
	self.remove_child(menu)
	menu.call_deferred("free")

	# Add the new menu
	current_menu = prepare_menu(menu_name)
	self.add_child(current_menu)
	self.move_child(current_menu, 0)
	emit_signal("music_changed", current_menu.music_name)

# Signals to propagate
func _on_configuration_toggled() -> void:
	emit_signal("configuration_toggled")

func _on_game_started() -> void:
	emit_signal("game_started")

func _on_game_exited() -> void:
	play_button_sound()
	emit_signal("game_exited")

#func next_menu(scene_name : String) -> void:
#	# Add the next interface or the main game instance
#	var scene_path : String = menu_path + scene_name + ".tscn"
#	var next_level_resource
#	next_level_resource = load(scene_path)
#	var next_level
#	next_level = next_level_resource.instance()
#
#	# Apply the menu connections
#	next_level.connect('goto_next_scene', self, '_on_goto_scene')
#	next_level.connect('goto_prev_scene', self, '_on_goto_scene')
#	next_level.connect('toggle_configuration', self, '_on_toggle_configuration')
#	next_level.connect('exit_game', self, '_on_exit_emitted')
#	if next_level.music != null:
#		SoundHandler.set_music_stream(next_level.music)
