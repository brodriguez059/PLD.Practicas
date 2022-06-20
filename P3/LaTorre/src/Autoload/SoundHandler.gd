extends Node


const music_path := "res://assets/audio/music/"

var audio_player : AudioStreamPlayer = null
var current_song : String = ""

func _ready() -> void:
	# Create a new node for audio control
	audio_player = AudioStreamPlayer.new()
	audio_player.bus = "Music"
	self.add_child(audio_player, true)

	# Configure the pause_mode
	self.pause_mode = PAUSE_MODE_PROCESS

# Music manipulation

func set_music_stream(music_name : String) -> void:
	if music_name != "" and music_name != current_song: # No tiene sentido cambiar la canción si es la misma
		clear_music_stream()
		current_song = music_name
		var music_stream = load(music_path + music_name)
		audio_player.stream = music_stream
		audio_player.play()

func clear_music_stream() -> void:
	audio_player.stop()
	audio_player.stream = null
	current_song = ""

# Volume and bus manipulation
func set_bus_volume(bus_name : String, vol : float) -> void:
	# Se necesita el índice del bus a modificar
	var idx = AudioServer.get_bus_index(bus_name)

	# El valor que entra en vol está en el rango [0,100]. Sin embargo, linear2db
	# necesita algo en el rango [0,1]. Se normaliza vol:
	var value = linear2db(vol/100)
	
	# Se cambia el volumen
	AudioServer.set_bus_volume_db(idx, value)

func set_master_volume(vol : float) -> void:
	set_bus_volume("Master", vol)
	
func set_fx_volume(vol : float) -> void:
	set_bus_volume("Fx", vol)
	
func set_music_volume(vol : float) -> void:
	set_bus_volume("Music", vol)
