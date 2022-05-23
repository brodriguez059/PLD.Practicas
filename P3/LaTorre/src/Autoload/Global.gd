extends Node

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var return_scene

var music_volume
var fx_volume

var profile : Profile_Data = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func read_player_data(index) -> Profile_Data:
	var path = "res://data/saves/profile%d.res" % index
	if ResourceLoader.exists(path):
		profile = ResourceLoader.load(path)
		if profile is Profile_Data: # Check that the data is valid
			return profile
	return null

func store_profile(index) -> void:
	var result = ResourceSaver.save("res://data/saves/profile%d.res" % index, profile)
	
func remove_profile(index) -> void:
	var dir = Directory.new()
	dir.remove("res://data/saves/profile%d.res" % index)
