extends Control

export(bool) var win_condition = false

# warning-ignore:unused_signal
signal game_exited(win)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func change_type(win : bool) -> void:
	win_condition = win
	hide()
	if win:
		$ColorRect/NinePatchRect/Label.text = "¡Victoria!"
	else:
		$ColorRect/NinePatchRect/Label.text = "Derrota..."
	show()

func _on_BttnAbandonar_pressed() -> void:
	emit_signal("game_exited", win_condition)
