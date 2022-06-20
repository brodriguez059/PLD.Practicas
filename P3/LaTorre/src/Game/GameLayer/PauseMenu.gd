extends Control

# warning-ignore:unused_signal
signal pause_toggled()
# warning-ignore:unused_signal
signal configuration_toggled()
# warning-ignore:unused_signal
signal game_abandoned()

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)

func _ready():
	hide()

func _on_BttnContinuar_pressed() -> void:
	emit_signal("pause_toggled")

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("configuration_toggled")

func _on_BttnSalir_pressed() -> void:
	emit_signal("game_abandoned")
