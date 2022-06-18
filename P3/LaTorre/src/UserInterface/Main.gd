extends Node2D

var menu_path := "res://src/UserInterface/Menus/"

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	OS.min_window_size = OS.window_size
	OS.max_window_size = OS.get_screen_size()
	Global.configuration = SaveFiles.read_general_configuration_data()
	Music.change_fx_volume(Global.configuration.fx_volume)
	Music.change_music_volume(Global.configuration.music_volume)
	Music.change_master_volume(Global.configuration.master_volume)

# Called when the node enters the scene tree for the first time AND its children are ready
func _ready() -> void:
	pass
	
func prepare_ui_node(is_ui : bool, scene_name : String):
	# Add the next interface or the main game instance
	var scene_path : String
	var next_level_resource
	var next_level
	if is_ui: # The next step is an interface
		scene_path = menu_path + scene_name + ".tscn"
		next_level_resource = load(scene_path)
		next_level = next_level_resource.instance()
		next_level.connect('goto_next_scene', self, '_on_goto_scene')
		next_level.connect('goto_prev_scene', self, '_on_goto_scene')
		next_level.connect('toggle_configuration', self, '_on_toggle_configuration')
		next_level.connect('exit_game', self, '_on_exit_emitted')
	else: # THe next step is the main game
		# Instancia del juego principal
		scene_path = scene_name + ".tscn"
		next_level_resource = load(scene_path)
		next_level = next_level_resource.instance()
		next_level.connect('toggle_configuration', self, '_on_toggle_configuration')
	return next_level

func _notification(what):
	if what == NOTIFICATION_WM_QUIT_REQUEST:
		print("[Main.tscn]: Notificación de terminación de programa capturada")
		print("¡Hasta luego!")
		SaveFiles.write_general_configuration_data(Global.configuration)
		self.get_tree().quit()

func _on_goto_scene(scene_name : String, is_ui : bool) -> void:
	if $MenuLayer.get_child_count() > 0:
		# Remove the current level
		var level = $MenuLayer.get_child(0)
		$MenuLayer.remove_child(level)
		level.call_deferred("free")
	
	var next_level = prepare_ui_node(is_ui, scene_name)

	if is_ui:
		$MenuLayer.add_child(next_level)
	else:
		self.add_child_below_node($MenuLayer, next_level)

func _on_toggle_configuration() -> void:
	# Current visibilty
	var vis = $ConfigurationLayer/Configuration.visible
	$ConfigurationLayer/Configuration.visible = not vis # <- toggle visibility

func _on_exit_emitted() -> void:
	self.get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func change_music_to(stream) -> void:
	$GameMusic.stream = ""
