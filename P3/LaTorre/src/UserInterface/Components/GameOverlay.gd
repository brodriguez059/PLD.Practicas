extends Control

signal toggle_pause

func _on_BttnPause_pressed() -> void:
	emit_signal("toggle_pause")
