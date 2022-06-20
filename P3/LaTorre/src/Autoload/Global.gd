extends Node

const save_path := "res://data/saves/"
const config_path := "res://data/config/"

# Profile information
var profile : Profile_Data = null
var profile_index : int = -1

# Game configuration information
var configuration : Configuration_data = null

# Game play/partida information
var play_data : Play_Game_Data = null
var on_game : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Configuration data
func get_configuration() -> Configuration_data:
	return configuration

func write_configuration(config_data : Configuration_data):
	var _result = ResourceSaver.save(config_path + "configuration.res", config_data)
	
func read_configuration():
	var path = config_path + "configuration.res"
	var config = null
	# Verificamos que exista
	if ResourceLoader.exists(path):
		# Si existe, lo cargamos
		config = ResourceLoader.load(path)
		if config is Configuration_data: # Check that the data is valid
			return config
	# Algo ha fallado, se considera el fichero como no existente o corrupto y se
	# vuelve a generar
	config = Configuration_data.new()
	config.master_volume = 100.0
	config.music_volume = 50.0
	config.fx_volume = 50.0
	# Se guarda la configuración
	write_configuration(config)
	return config

# Profile data manipulation methods

func set_profile(prof_data : Profile_Data, idx : int) -> void:
	profile = prof_data
	profile_index = idx

func get_profile() -> Dictionary:
	return {"profile":profile, "index":profile_index}
	
func clear_profile() -> void:
	profile = null
	profile_index = -1

func write_profile(profile_data : Profile_Data, idx : int):
	var path = save_path + ("profile%d.res" % idx)
	var _result = ResourceSaver.save(path, profile_data)

func read_profile(idx : int):
	var path = save_path + ("profile%d.res" % idx)
	if ResourceLoader.exists(path): # Se verifica que existe
		var prof := ResourceLoader.load(path)
		if prof is Profile_Data: # Check that the data is valid
			return prof
	return null # ¿No existe el perfil?

func delete_profile(index):
	var dir = Directory.new()
	var path = save_path + ("profile%d.res" % index)
	dir.remove(path)

# Game play/partida information
func set_play(pl_data : Play_Game_Data) -> void:
	play_data = pl_data
	on_game = false

func get_play() -> Dictionary:
	return {"play_game":play_data, "on_game":on_game}

func clear_play() -> void:
	play_data = null
	on_game = false
	
func toggle_on_game() -> void:
	on_game = not on_game
