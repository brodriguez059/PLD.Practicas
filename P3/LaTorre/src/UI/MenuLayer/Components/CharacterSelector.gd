extends Control

export(String) var list_characters = null
export(String) var current_character = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_BttnNext_pressed() -> void:
	$ChangePageAudio.stop()
	$ChangePageAudio.play()
	print("Next character pls")

func _on_BttnPrev_pressed() -> void:
	$ChangePageAudio.stop()
	$ChangePageAudio.play()
	print("Previous character pls")
