extends Control

export(bool) var win_condition = false

# warning-ignore:unused_signal
signal game_exited(win)

var multijugador : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func show_win_status(win : bool) -> void:
	win_condition = win
	var mensaje = ""
	hide()
	if win:
		mensaje = "¡Victoria!"
		if multijugador:
			mensaje = "Gana el jugador 1"
		$ColorRect/NinePatchRect/Label.text = mensaje
	else:
		mensaje = "Derrota..."
		if multijugador:
			mensaje = "Gana el jugador 2"
		$ColorRect/NinePatchRect/Label.text = mensaje
	show()

func _on_BttnAbandonar_pressed() -> void:
	emit_signal("game_exited", win_condition)
