extends Control

# warning-ignore:unused_signal
signal toggle_pause()
# warning-ignore:unused_signal
signal toggle_configuration()
# warning-ignore:unused_signal
signal terminate_game()

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)

func _ready():
	hide()

func _on_BttnContinuar_pressed() -> void:
	emit_signal("toggle_pause")

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("toggle_configuration")

func _on_BttnSalir_pressed() -> void:
	emit_signal("terminate_game")
