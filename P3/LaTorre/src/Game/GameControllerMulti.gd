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

onready var _pause_menu = $InterfaceLayer/PauseMenu
onready var _end_game_menu = $InterfaceLayer/EndGameMenu

onready var viewport1 = $Black/HSplitContainer/ViewportContainer1/ViewportLevel1
onready var viewport2 = $Black/HSplitContainer/ViewportContainer2/ViewportLevel2

onready var game_overlays = [viewport1.get_node(@"CanvasLayer/GameOverlay"), viewport2.get_node(@"CanvasLayer/GameOverlay")]

# The player instances
var players_instances : Array = [null, null]
# The assigned level container for each player. Represents the location
var players_location : Array = [0,0]

# The level containers
onready var levels_containers : Array = [viewport1, viewport2]
# The level instances
var levels_instances : Array = [null, null]
# The number of players inside a level
var levels_player_count : Array = [0,0]

# Number of levels initialized
var num_levels_mem : int = 0
# Current level index. Representa siempre al siguiente índice del array de niveles con un espacio
# vacío. Si no hay ninguno vacío, es igual a num_levels_mem (2)
var cur_level_idx : int = 0

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
func _ready() -> void:
	# Add 1 to number of plays
	Global.incr_stat("number_of_plays")
	_end_game_menu.multijugador = true
	
	# Initialize the new level
	var new_level_path = level_path + "Level1.tscn"
	if initial_level != "":
		new_level_path = level_path + initial_level + ".tscn"
	var new_level = add_level(new_level_path)
	
	# Initiliaze the players
	# aquí new_level nunca empezará como null
	initialize_character(0, Global.play_data.player1_character_class, new_level)
	viewport2.world_2d = viewport1.world_2d
	initialize_character(1, Global.play_data.player2_character_class, new_level)
	
	# Game overlay connections
	
	
func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("toggle_pause"):
		toggle_pause()
		get_tree().set_input_as_handled()

func force_music_change() -> void:
	var level = levels_containers[0].get_child(0)
	if level != null and level.music_name != "":
		emit_signal("music_changed", level.music_name)

func initialize_character(player_index : int, character_class : String, level : Level):
	# Load the resource
	var player_path = character_path + character_class + ".tscn"
	var player_resource = load(player_path)
	var player : Character = player_resource.instance()
	player.player_code = "_p" + str(player_index+1)
	level.add_child(player, true)
	player.set_label("P" + str(player_index+1))
	
	# Static types are necessary here to avoid warnings.
	var camera: Camera2D = player.camera
	# Only happens on multiplayer:
	if player_index == 0:
		camera.custom_viewport = viewport1
		yield(get_tree(), "idle_frame")
		camera.make_current()
	elif player_index == 1:
		camera.custom_viewport = viewport2
		yield(get_tree(), "idle_frame")
		camera.make_current()
	
	# Move the character to the specified starting point of the level
	level.initialize_character_inside_level(player)
	# If IA, setup the character IA. The connections are different too:
	
	# Player connections
	player.connect("health_changed", game_overlays[player_index], "change_health")
	player.connect("mana_changed", game_overlays[player_index], "change_mana")
	player.connect("coin_picked", _pause_menu, "change_coins")
	if player_index == 0:
		player.connect("player_died", self, "_on_player1_dead")
	elif player_index == 1:
		player.connect("player_died", self, "_on_player2_dead")

	# Setup the players inside the level

func add_level(level_name : String):
	if num_levels_mem < 2:
		var new_level_resource = load(level_name)
		var new_level = new_level_resource.instance()
		# Add the level
		levels_instances[cur_level_idx] = new_level
		levels_containers[cur_level_idx].add_child(new_level)
		levels_containers[cur_level_idx].move_child(new_level, 0)
		# Update state variables
		num_levels_mem += 1
		cur_level_idx = (cur_level_idx + 1) % 2
		# Ya hay dos niveles instanciados a la vez
		if num_levels_mem == 2:
			cur_level_idx = 2
		# Connect the signals
		new_level.connect("next_level_accessed", self, "_on_next_level_accessed")
		new_level.connect("music_changed", self, "_on_music_changed")
		return new_level
	else:
		print("[GameControllerMulti.tscn]:add_level -> There is an error")
		return null
		
func remove_level(index : int) -> void:
	if num_levels_mem >= 0:
		# Remove the level
		levels_containers[index].remove_child(levels_instances[index])
		levels_instances[index].call_deferred("free")
		# Update state variables
		num_levels_mem -= 1
		# Use this index as cur_index
		cur_level_idx = index
	else:
		print("[GameController.tscn]:remove_level -> There is an error")

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	_pause_menu.visible = not _pause_menu.visible

# Level signal handlers

func _on_next_level_accessed(next_level) -> void:
	print("[GameController.tscn] -> Next level accessed handler request")
	if next_level == "": # No hay siguiente nivel, entonces victoria
		emit_signal("music_changed", "victoria.wav")
		get_tree().paused = true
		_end_game_menu.show_win_status(true)
	else: # Hay siguiente nivel
		pass
		# Old code:
		#		var level = self.get_child(0)
		#		self.remove_child(level)
		#		level.call_deferred("free")
		#		var next_level_resource = load(level_path + next_level + ".tscn")
		#		level = next_level_resource.instance()
		#		level.connect("goto_next", self, "goto_next_level")
		#		self.add_child(level, true)
		#		self.move_child(level, 0)
		# New code:
		# Remove the current level
		# Add the next level

func _on_music_changed(music_name) -> void:
	emit_signal("music_changed", music_name)

func _on_player1_dead() -> void:
	emit_signal("music_changed", "derrota.wav")
	get_tree().paused = true
	_end_game_menu.show_win_status(false) # Esto significa derrota

func _on_player2_dead() -> void:
	emit_signal("music_changed", "victoria.wav")
	get_tree().paused = true
	_end_game_menu.show_win_status(true) # Esto significa victoria

func _on_game_lost() -> void:
	emit_signal("music_changed", "derrota.wav")
	get_tree().paused = true
	_end_game_menu.show_win_status(false) # Esto significa derrota

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
