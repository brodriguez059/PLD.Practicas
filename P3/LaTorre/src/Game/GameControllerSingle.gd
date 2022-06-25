extends Node

# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal music_changed(music_stream)
# warning-ignore:unused_signal
signal game_finished(win)

const level_path = "res://src/Levels/"
const character_path = "res://src/Actors/Characters/"

export(String) var initial_level = ""

onready var pause_menu = $InterfaceLayer/PauseMenu
onready var game_overlay = $InterfaceLayer/GameOverlay
onready var end_game_menu = $InterfaceLayer/EndGameMenu

# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenu
onready var _overlay = $InterfaceLayer/GameOverlay

var player = null # Can't use static typing as it causes circular dependency
var level = null

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
func _ready() -> void:
	# Add 1 to number of plays
	Global.incr_stat("number_of_plays")
	
	# Initialize the new level
	var new_level_path = (level_path + "Level1.tscn") if initial_level == "" else level_path + initial_level + ".tscn"
	level = add_level(new_level_path)
	
	# Initiliaze the players
	# aquí new_level nunca entrará como null
	player = create_character(Global.play_data.player1_character_class, level)
	
	
func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("toggle_pause"):
		toggle_pause()
		get_tree().set_input_as_handled()

func create_character(character_class : String, level : Level):
	# Load the resource
	var player_path = character_path + character_class + ".tscn"
	var player_resource = load(player_path)
	var player_local = player_resource.instance()
	self.add_child_below_node(level, player_local, true)
	
	initialize_character(player_local, level)
	
	return player_local
	
func initialize_character(player_local, level : Level):
	# If IA, setup the character IA. The connections are different too:
	# Player connections
	player_local.connect("health_changed", _overlay, "change_health")
	player_local.connect("mana_changed", _overlay, "change_mana")
	player_local.connect("coin_picked", _pause_menu, "change_coins")
	player_local.connect("player_died", self, "_on_game_lost")
	
	# Move the character to the specified starting point of the level
	# Setup the players inside the level
	level.initialize_character_inside_level(player_local)

	return player_local

func add_level(level_name : String):
	var new_level_resource = load(level_name)
	var new_level = new_level_resource.instance()
	# Add the level
	self.add_child(new_level)
	self.move_child(new_level, 0)
	# Connect the signals
	new_level.connect("next_level_accessed", self, "_on_next_level_accessed")
	new_level.connect("music_changed", self, "_on_music_changed")
	return new_level

func remove_level(index : int) -> void:
	# Remove the level
	var level_ref = self.get_child(index)
	self.remove_child(level_ref)
	level_ref.call_deferred("free")

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = not pause_menu.visible
	
func force_music_change() -> void:
	if level.music_name != "":
		emit_signal("music_changed", level.music_name)

# Level signal handlers

func _on_next_level_accessed(next_level, player_local) -> void:
	print("[GameController.tscn] -> Next level accessed handler request")
	if next_level == "": # No hay siguiente nivel, entonces victoria
		emit_signal("music_changed", "victoria.wav")
		get_tree().paused = true
		end_game_menu.show_win_status(true)
	else: # Hay siguiente nivel
		# Remove child
		remove_level(0)
		var new_level = add_level(next_level)
		initialize_character(player, new_level)

func _on_music_changed(music_name) -> void:
	emit_signal("music_changed", music_name)

func _on_game_lost() -> void:
	emit_signal("music_changed", "derrota.wav")
	get_tree().paused = true
	end_game_menu.show_win_status(false) # Esto significa derrota

# UI function handlers
func _on_pause_toggled() -> void:
	toggle_pause()

func _on_PauseMenu_configuration_toggled() -> void:
	emit_signal("configuration_toggled")

func _on_EndGameMenu_game_exited(win) -> void:
	get_tree().paused = false
	if not win:
		Global.incr_stat("number_of_loses")
	else:
		Global.incr_stat("number_of_wins")
	Global.on_game = false
	emit_signal("game_finished", win)
