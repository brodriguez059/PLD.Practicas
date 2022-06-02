extends Node

var save_path := "res://data/saves/"
var config_path := "res://data/config/"

func write_profile_data(index, profile_data):
	var _result = ResourceSaver.save(save_path + ("profile%d.res" % index), profile_data)
	
func read_profile_data(index):
	var path = save_path + ("profile%d.res" % index)
	if ResourceLoader.exists(path):
		var profile := ResourceLoader.load(path)
		if profile is Profile_Data: # Check that the data is valid
			return profile
	return null
	
func delete_profile_data(index):
	var dir = Directory.new()
	dir.remove("res://data/saves/profile%d.res" % index)

func write_general_configuration_data(config_data):
	var _result = ResourceSaver.save(config_path + "configuration.res", config_data)
	
func read_general_configuration_data():
	var path = config_path + "configuration.res"
	var config = null
	if ResourceLoader.exists(path):
		config = ResourceLoader.load(path)
		if config is Configuration_data: # Check that the data is valid
			return config
	# Something went wrong, there is no config file
	# Creamos la configuración
	config = Configuration_data.new()
	config.master_volume = 100.0
	config.music_volume = 50.0
	config.fx_volume = 50.0
	write_general_configuration_data(config)
	return config
