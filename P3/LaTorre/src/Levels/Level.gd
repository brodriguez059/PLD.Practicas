extends Node2D

# warning-ignore:unused_signal
signal music_changed(music_stream)
# warning-ignore:unused_signal
signal goto_next(next_level)

export(String) var music_name = ""
export(String) var next_level = ""

onready var door_in = $Doors/DoorIn
onready var door_out = $Doors/DoorOut

func _ready():
	if music_name != "":
		emit_signal("music_changed", music_name)
	door_out.connect("door_opened", self, "_on_DoorOut_door_opened")

func enter_character(character : Character) -> void:
	if character != null:
		character.position = $Doors/DoorIn.position

func _on_DoorOut_door_opened() -> void:
	emit_signal("goto_next", next_level)
