extends Node2D

onready var menu_lay = $MenuLayer
onready var conf_lay = $ConfigurationLayer
onready var trans_lay = $TransitionLayer

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
				Global.incr_stat("number_of_loses")
			Global.write_profile(Global.profile, Global.profile_index)
		self.get_tree().quit()

# Signal handlers

# Menu Layer signals
func _on_music_changed(music_stream):
	SoundHandler.set_music_stream(music_stream)

func _on_game_exited() -> void:
	self.get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _on_menu_changed(speed) -> void:
	trans_lay.start_transition(speed)

func _on_game_started() -> void:
	#Instancia del juego principal
	var next_level_resource_path = "res://src/Game/GameController"
	if Global.play_data.play_mode == 1:
		next_level_resource_path += "Multi.tscn"
	else:
		next_level_resource_path += "Single.tscn"
	var next_level_resource = load(next_level_resource_path)
	var next_level = next_level_resource.instance()
	self.add_child(next_level)
	self.move_child(next_level, 0)
	next_level.connect("configuration_toggled", conf_lay, "toggle_configuration")
	next_level.connect("music_changed", self, "_on_music_changed")
	next_level.connect('game_finished', self, '_on_game_finished')
	current_game = next_level
	Global.on_game = true
	
	next_level.force_music_change() # <- Needs to be done like this to force the new music

func _on_game_finished(win) -> void:
	# Eliminamos la instancia del juego
	self.remove_child(current_game)
	current_game.call_deferred("free")
	current_game = null

	if win:
		print("[Main.tscn:_on_game_finished -> You win...]")
	else:
		print("[Main.tscn:_on_game_finished -> You lose...]")

	menu_lay.access_menu("ProfileView")
