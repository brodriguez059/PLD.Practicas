extends Transitionable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_BttnRegresar_pressed() -> void:
	emit_signal("goto_prev_scene", prev_scene, true)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("toggle_configuration")

func _on_BttnCreateGame_pressed() -> void:
	#TODO: No olvides mandar la info de la partida nueva al selector de personajes
	emit_signal("goto_next_scene", next_scene, true)
