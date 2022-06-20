extends Node

# warning-ignore:unused_signal
signal toggle_pause()
# warning-ignore:unused_signal
signal toggle_configuration()
# warning-ignore:unused_signal
signal game_won()
# warning-ignore:unused_signal
signal game_lost()

const level_path = "res://src/Levels/"

# The "_" prefix is a convention to indicate that variables are private,
# that is to say, another node or script should not access them.
onready var _pause_menu = $InterfaceLayer/PauseMenu
onready var _overlay = $InterfaceLayer/GameOverlay
onready var _player_instance1 = $Player
onready var _player_instance2 = null
onready var _level = $Level

func _init():
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
func _ready() -> void:
	# Player connections
	_player_instance1.connect("health_changed", _overlay, "change_health")
	_player_instance1.connect("mana_changed", _overlay, "change_mana")
	_player_instance1.connect("player_died", self, "")
	
	# Game overlay connections
	_overlay.connect("death_detected", self, "_on_terminate_game")
	
	# Level connections
	_level.connect("goto_next", self, "goto_next_level")

func _unhandled_input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
		get_tree().set_input_as_handled()
	# The GlobalControls node, in the Stage scene, is set to process even
	# when the game is paused, so this code keeps running.
	# To see that, select GlobalControls, and scroll down to the Pause category
	# in the inspector.
#	elif event.is_action_pressed("toggle_pause"):
#		var tree = get_tree()
#		tree.paused = not tree.paused
#		if tree.paused:
#			_pause_menu.open()
#		else:
#			_pause_menu.close()
#		get_tree().set_input_as_handled()

func _on_FinishGame_finish_game(win) -> void:
	if not win:
		Global.profile.number_of_loses += 1
		if Global.profile.number_of_loses != 0:
			Global.profile.ratio_win_lose = float(Global.profile.number_of_wins) / float(Global.profile.number_of_loses)
		else:
			Global.profile.ratio_win_lose = INF
		get_tree().paused = false
		emit_signal("game_lost")
	else:
		Global.profile.number_of_wins += 1
		if Global.profile.number_of_loses != 0:
			Global.profile.ratio_win_lose = float(Global.profile.number_of_wins) / float(Global.profile.number_of_loses)
		else:
			Global.profile.ratio_win_lose = INF
		get_tree().paused = false
		emit_signal("game_won")

func goto_next_level(next_level) -> void:
	print("Toca ir al siguiente nivel")
	if next_level == "":
		Music.change_music("victoria.wav")
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

func _on_toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	var vis = $InterfaceLayer/PauseMenu.visible
	$InterfaceLayer/PauseMenu.visible = not vis
	emit_signal("toggle_pause")

func _on_toggle_configuration() -> void:
	emit_signal("toggle_configuration")

func _on_toggle_abandon() -> void:
	pass

func _on_terminate_game() -> void:
	Music.change_music("derrota.wav")
	get_tree().paused = true
	$InterfaceLayer/FinishGame.change_type(false) # Esto significa derrota
