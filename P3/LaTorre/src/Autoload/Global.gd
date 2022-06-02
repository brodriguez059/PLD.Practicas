extends Node

var return_scene
var profile : Profile_Data = null
var configuration : Configuration_data = null
var play_data : Play_Game_Data = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	configuration = SaveFiles.read_general_configuration_data()
