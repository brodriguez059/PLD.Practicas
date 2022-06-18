extends Control

signal toggle_pause
signal toggle_configuration
signal terminate_game

func _on_BttnContinuar_pressed() -> void:
	emit_signal("toggle_pause")

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("toggle_configuration")

func _on_BttnSalir_pressed() -> void:
	emit_signal("terminate_game")
