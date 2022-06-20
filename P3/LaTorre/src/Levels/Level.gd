extends Node2D

# warning-ignore:unused_signal
signal goto_next(next_level)

const LIMIT_LEFT = -315
const LIMIT_TOP = -250
const LIMIT_RIGHT = 955
const LIMIT_BOTTOM = 690

export(String) var next_music = ""
export(String) var next_level = ""

onready var door_out = $Doors/DoorOut

func _ready():
	for child in get_children():
		if child is Character:
			var camera = child.get_node("Camera")
			camera.limit_left = LIMIT_LEFT
			camera.limit_top = LIMIT_TOP
			camera.limit_right = LIMIT_RIGHT
			camera.limit_bottom = LIMIT_BOTTOM
	var pl : Character = get_node(@"../Player")
	if pl != null:
		pl.position = $Doors/DoorIn.position
	if next_music != "":
		Music.change_music(next_music)
	door_out.connect("door_opened", self, "_on_DoorOut_door_opened")

func _on_DoorOut_door_opened() -> void:
	emit_signal("goto_next", next_level)
