extends Transitionable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # TODO Buscar una forma de animar el inicio

func _on_BttnInicio_pressed() -> void:
	emit_signal("goto_next_scene", next_scene, true)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("toggle_configuration")

func _on_BttnSalir_pressed() -> void:
	emit_signal("exit_game")
