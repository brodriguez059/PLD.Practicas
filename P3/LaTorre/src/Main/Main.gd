extends Node2D

var current_game = null

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	# Window configuration
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	
	# Global configuration initializer
	Global.configuration = Global.read_configuration()
	
	# Music and volume controller
	SoundHandler.set_fx_volume(Global.configuration.fx_volume)
	SoundHandler.set_music_volume(Global.configuration.music_volume)
	SoundHandler.set_master_volume(Global.configuration.master_volume)
	
# Called when the node enters the scene tree for the first time AND its children are ready
func _ready() -> void:
	pass

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		print("[Main.tscn]: Notificación de terminación de programa capturada")
		print("¡Hasta luego!")

		# Se guarda la configuración general
		Global.write_configuration(Global.configuration)
		if Global.profile:
			if Global.on_game: # Hay una partida ahora mismo
				Global.profile.number_of_loses += 1
				if Global.profile.number_of_loses != 0:
					Global.profile.ratio_win_lose = float(Global.profile.number_of_wins) / float(Global.profile.number_of_loses)
				else:
					Global.profile.ratio_win_lose = INF
			Global.write_profile(Global.profile, Global.profile_index)
		self.get_tree().quit()

#func prepare_ui_node(is_ui : bool, scene_name : String):
#	# Add the next interface or the main game instance
#	var scene_path : String
#	var next_level_resource
#	var next_level
#	if is_ui: # The next step is an interface
#		scene_path = menu_path + scene_name + ".tscn"
#		next_level_resource = load(scene_path)
#		next_level = next_level_resource.instance()
#		next_level.connect('goto_next_scene', self, '_on_goto_scene')
#		next_level.connect('goto_prev_scene', self, '_on_goto_scene')
#		next_level.connect('toggle_configuration', self, '_on_toggle_configuration')
#		next_level.connect('exit_game', self, '_on_exit_emitted')
#		Global.on_game = false
#		if next_level.new_music != "":
#			SoundHandler.change_music(next_level.new_music)
#	else: # THe next step is the main game
#		# Instancia del juego principal
#		scene_path = scene_name + ".tscn"
#		next_level_resource = load(scene_path)
#		next_level = next_level_resource.instance()
#		next_level.connect('toggle_configuration', self, '_on_toggle_configuration')
#		next_level.connect('toggle_pause', self, '_on_toggle_pause')
#		next_level.connect('game_lost', self, '_on_game_lost')
#		next_level.connect('game_won', self, '_on_game_won')
#		Global.on_game = true
#	return next_level

#func _on_goto_scene(scene_name : String, is_ui : bool) -> void:
#	$UIFxSound.stop()
#	$UIFxSound.stream = sfx_button
#	$UIFxSound.play()
#	if $MenuLayer.get_child_count() > 0:
#		# Remove the current level
#		var level = $MenuLayer.get_child(0)
#		$MenuLayer.remove_child(level)
#		level.call_deferred("free")
#
#	var next_level = prepare_ui_node(is_ui, scene_name)
#
#	if is_ui:
#		$MenuLayer.add_child(next_level)
#	else:
#		current_game = next_level
#		self.add_child_below_node($MenuLayer, next_level)
#

	
#func game_finished() -> void:
#	if $MenuLayer.get_child_count() > 0:
#		# Remove the current game
#		var level = $MenuLayer.get_child(0)
#		$MenuLayer.remove_child(level)
#		level.call_deferred("free")
#
#	# Remove the game
#	self.remove_child(current_game)
#	current_game.call_deferred("free")
#	current_game = null
#
#	# Go to the profile view
#	var scene_path = menu_path + "ProfileView.tscn"
#	var next_level_resource = load(scene_path)
#	var next_level = next_level_resource.instance()
#	next_level.connect('goto_next_scene', self, '_on_goto_scene')
#	next_level.connect('goto_prev_scene', self, '_on_goto_scene')
#	next_level.connect('toggle_configuration', self, '_on_toggle_configuration')
#	next_level.connect('exit_game', self, '_on_exit_emitted')
#	Global.on_game = false
#	SoundHandler.change_music("Menus.wav")
#	$MenuLayer.add_child(next_level)

# Signal handlers

# Play game signals

#func _on_game_lost() -> void:
#	print("[Main.tscn: You lose...]")
#	game_finished()
#
#func _on_game_won() -> void:
#	print("[Main.tscn: You win...]")
#	game_finished()

# Menu Layer signals
func _on_music_changed(music_stream):
	SoundHandler.set_music_stream(music_stream)

func _on_game_exited() -> void:
	self.get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
