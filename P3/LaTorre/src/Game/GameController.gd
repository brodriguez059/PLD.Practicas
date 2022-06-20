extends Node

# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal music_changed(music_stream)
# warning-ignore:unused_signal
signal game_finished(win)

const level_path = "res://src/Levels/"

export(String) var initial_level = ""

onready var pause_menu = $InterfaceLayer/PauseMenu
onready var game_overlay = $InterfaceLayer/GameOverlay
onready var end_game_menu = $InterfaceLayer/EndGameMenu

# The player instances
var players_instances : Array = [null, null]
# The level in which each player is located
var players_location : Array = [0,0]

# The level containers
onready var levels_containers : Array = [$LevelContainer1, $LevelContainer2]
# The level instances
var levels_instances : Array = [null, null]
# The number of players inside a level
var levels_player_count : Array = [0,0]

# Number of levels on memory
var num_levels_mem : int = 0
# Current level index
var cur_level_idx : int = 0

# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenu
onready var _overlay = $InterfaceLayer/GameOverlay

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
func _ready() -> void:
	# Add 1 to number of plays
	Global.incr_stat("number_of_plays")
	
	# Initialize the new level
	var new_level_path = level_path + "Level1.tscn"
	if initial_level != "":
		new_level_path = level_path + initial_level + ".tscn"

	add_level(new_level_path)
	
	# Player connections
	#_player_instance1.connect("health_changed", _overlay, "change_health")
	#_player_instance1.connect("mana_changed", _overlay, "change_mana")
	#_player_instance1.connect("player_died", self, "")
	
	# Game overlay connections
	_overlay.connect("death_detected", self, "_on_terminate_game")
	
	# Level connections
	#_level.connect("goto_next", self, "goto_next_level")
	
func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("toggle_pause"):
		toggle_pause()
		get_tree().set_input_as_handled()

func add_level(level_name : String) -> void:
	if num_levels_mem < 2:
		var new_level_resource = load(level_name)
		var new_level = new_level_resource.instance()
		# Add the level
		levels_containers[cur_level_idx].add_child(new_level)
		levels_instances[cur_level_idx] = new_level
		# Update state variables
		num_levels_mem += 1
		cur_level_idx = (cur_level_idx + 1) % 2
	else:
		print("[GameController.tscn]:add_level -> There is an error")
		
func remove_level(index : int) -> void:
	if num_levels_mem >= 0:
		# Remove the level
		levels_containers[index].remove_child(levels_instances[index])
		levels_instances[index].call_deferred("free")
		# Update state variables
		num_levels_mem -= 1
	else:
		print("[GameController.tscn]:remove_level -> There is an error")

func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	pause_menu.visible = not pause_menu.visible

func goto_next_level(next_level) -> void:
	print("Toca ir al siguiente nivel")
	if next_level == "":
		SoundHandler.set_music_stream("victoria.wav")
		get_tree().paused = true
		$InterfaceLayer/FinishGame.change_type(true)
	else:
		# Remove the current level
		var level = self.get_child(0)
		self.remove_child(level)
		level.call_deferred("free")
		
		var next_level_resource = load(level_path + next_level + ".tscn")
		level = next_level_resource.instance()
		level.connect("goto_next", self, "goto_next_level")
		self.add_child(level, true)
		self.move_child(level, 0)

# UI function handlers
func _on_pause_toggled() -> void:
	toggle_pause()

func _on_PauseMenu_configuration_toggled() -> void:
	emit_signal("configuration_toggled")

func _on_PauseMenu_game_abandoned() -> void:
	emit_signal("music_changed", "derrota.wav")
	get_tree().paused = true
	end_game_menu.change_type(false) # Esto significa derrota

func _on_EndGameMenu_game_exited(win) -> void:
	get_tree().paused = false
	if not win:
		Global.incr_stat("number_of_loses")
	else:
		Global.incr_stat("number_of_wins")
	emit_signal("game_finished", win)
