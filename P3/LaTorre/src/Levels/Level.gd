class_name Level
extends Node2D

var LIMIT_LEFT = -315
var LIMIT_TOP = -250
var LIMIT_RIGHT = 955
var LIMIT_BOTTOM = 690

# warning-ignore:unused_signal
signal music_changed(music_stream)
# warning-ignore:unused_signal
signal next_level_accessed(next_level, player)

export(String) var music_name = ""
export(String) var next_level = ""

onready var door_in = $Doors/DoorIn
onready var door_out = $Doors/DoorOut

func _ready():
	if music_name != "":
		emit_signal("music_changed", music_name)
	door_out.connect("door_opened", self, "_on_DoorOut_door_opened")
	
	# Only happens on multiplayer:
	for child in get_children():
		if child is Character:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM

func initialize_character_inside_level(character : Character) -> void:
	if character != null:
		character.position = $Doors/DoorIn.position

func _on_DoorOut_door_opened(player) -> void:
	emit_signal("next_level_accessed", next_level, player)
