extends Transitionable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_BttnSelect_pressed() -> void:
	# ESTA ES UNA DE LAS FUNCIONES MÁS IMPORTANTES DE TU JUEGO
	# DESDE AQUÍ SE VA A LA PARTIDA DE VERDAD
	print("Empieza la partida")
	print("Esperando a los demás jugadores...")
	emit_signal("goto_next_scene", next_scene, false)
	
func _on_BttnRegresar_pressed() -> void:
	emit_signal("goto_prev_scene", prev_scene, true)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("toggle_configuration")

func _on_BttnPrev_toggled(button_pressed: bool) -> void:
	pass # Replace with function body.

func _on_BttnNext_pressed() -> void:
	pass # Replace with function body.
