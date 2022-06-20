extends GameMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_BttnSelect_pressed() -> void:
	emit_signal("button_fx_played")
	# ESTA ES UNA DE LAS FUNCIONES MÁS IMPORTANTES DE TU JUEGO
	# DESDE AQUÍ SE VA A LA PARTIDA DE VERDAD
	print("Empieza la partida")
	print("Esperando a los demás jugadores...")
	Global.profile.number_of_plays += 1
	emit_signal("game_started")


# Character selection

func _on_BttnNext_pressed() -> void:
	pass

func _on_BttnPrev_pressed() -> void:
	pass


# UI signals emitters

func _on_BttnRegresar_pressed() -> void:
	emit_signal("button_fx_played")
	Global.clear_play()
	emit_signal("prev_menu_accessed", prev_menu)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("configuration_toggled")
