extends NinePatchRect

signal activate_action(metadata)

var metadata = null

func _ready() -> void:
	pass # Replace with function body.

func _on_BttnAction_pressed() -> void:
	emit_signal("activate_action", metadata)
