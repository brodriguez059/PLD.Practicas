extends Node

func change_bus_volume(bus_name : String, vol : float) -> void:
	var idx = AudioServer.get_bus_index(bus_name)
	# vol \in [0,100], pero linear2db necesita [0,1]
	# Se normaliza vol:
	var value = linear2db(vol/100)
	AudioServer.set_bus_volume_db(idx, value)

func change_master_volume(vol : float) -> void:
	change_bus_volume("Master", vol)
	
func change_fx_volume(vol : float) -> void:
	change_bus_volume("Fx", vol)
	
func change_music_volume(vol : float) -> void:
	change_bus_volume("Music", vol)
