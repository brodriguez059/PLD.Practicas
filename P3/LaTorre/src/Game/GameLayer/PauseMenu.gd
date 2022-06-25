extends Control

# warning-ignore:unused_signal
signal pause_toggled()
# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal game_abandoned()

onready var counter = $ColorRect/CoinsCounter

func _ready():
	hide()

# Auxiliary functions

func _unhandled_input(event):
	if event.is_action_pressed("toggle_pause"):
		get_tree().set_input_as_handled()
		emit_signal("pause_toggled")

func change_coins(value : int) -> void:
	counter.set_coins(value)

# UI signal handlers

func _on_BttnContinuar_pressed() -> void:
	emit_signal("pause_toggled")

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("configuration_toggled")

func _on_BttnSalir_pressed() -> void:
	emit_signal("game_abandoned")
