extends GameMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO Aplicar animación al principio
	pass

# Auxilary functions



# UI signal emitters
func _on_BttnInicio_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("next_menu_accessed", next_menu)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("configuration_toggled")

func _on_BttnSalir_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("game_exited")
