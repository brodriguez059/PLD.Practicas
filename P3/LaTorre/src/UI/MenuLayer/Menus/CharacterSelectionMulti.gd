extends GameMenu

onready var player1_selector = $NinePatchRect/NinePatchRect/CharacterSelectorPlayer1
onready var player2_selector = $NinePatchRect/NinePatchRect/CharacterSelectorPlayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_BttnSelect_pressed() -> void:
	emit_signal("button_fx_played")
	var player1_data = player1_selector.get_character()
	Global.play_data.player1_character_class = player1_data["class"]
	var player2_data = player2_selector.get_character()
	Global.play_data.player2_character_class = player2_data["class"]
	emit_signal("game_started")

# UI signals emitters
func _on_BttnRegresar_pressed() -> void:
	emit_signal("button_fx_played")
	Global.clear_play()
	emit_signal("prev_menu_accessed", prev_menu)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("configuration_toggled")
