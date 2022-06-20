extends CanvasLayer

# Signals
# warning-ignore:unused_signal
signal menu_changed(speed)
# warning-ignore:unused_signal
signal music_changed(music_stream)
# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal game_started()
# warning-ignore:unused_signal
signal game_exited()

# Constants
const menu_path : String = "res://src/UI/MenuLayer/Menus/"

# Exported variables
export(String) var initial_menu = ""
export(float, 0.1, 1.0) var transition_speed = 0.35

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

func access_menu(menu_name : String) -> void:
	# Remove the menu
	emit_signal("menu_changed", 1.0/transition_speed)
	yield(get_tree().create_timer(transition_speed), "timeout")
	if self.get_child_count() > 1: # Como mínimo está el ButtonFx
		var menu = self.get_child(0)
		self.remove_child(menu)
		menu.call_deferred("free")

	# Add the new menu
	current_menu = prepare_menu(menu_name)
	self.add_child(current_menu)
	self.move_child(current_menu, 0)
	emit_signal("music_changed", current_menu.music_name)

# UI signal handlers
func _on_button_fx_played() -> void:
	play_button_sound()

# Next menu + Prev menu
func _on_menu_accessed(menu_name) -> void:
	access_menu(menu_name)

# Signals to propagate
func _on_configuration_toggled() -> void:
	emit_signal("configuration_toggled")

func _on_game_started() -> void:
	# Eliminamos la instancia del menú
	var menu = self.get_child(0)
	self.remove_child(menu)
	menu.call_deferred("free")
	# Emitimos la señal de que empieza el juego
	emit_signal("game_started")

func _on_game_exited() -> void:
	play_button_sound()
	emit_signal("game_exited")
