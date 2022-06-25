extends GameMenu

onready var mode_selector : OptionButton = $NinePatchRect/NinePatchRect/VBoxContainer/ModeContainer/Mode
onready var difficulty_selector : OptionButton = $NinePatchRect/NinePatchRect/VBoxContainer/DifficultyContainer/Difficulty

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.play_data != null:
		mode_selector.select(Global.play_data.play_mode)
		difficulty_selector.select(Global.play_data.play_difficulty)
	else:
		mode_selector.select(0) # Multiplayer by default
		difficulty_selector.select(0)
	

func _on_BttnRegresar_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("prev_menu_accessed", prev_menu)

func _on_BttnCreateGame_pressed() -> void:
	emit_signal("button_fx_played")
	
	# Extraemos la información de la partida
	var pl_gm_data : Play_Game_Data = Play_Game_Data.new()
	pl_gm_data.play_mode = mode_selector.selected
	pl_gm_data.play_difficulty = difficulty_selector.selected
	
	# La asignamos al controlador
	Global.set_play(pl_gm_data)
	
	# Siguiente menú
	var mode_name = "Single" if pl_gm_data.play_mode == 0 else "Multi"
	emit_signal("next_menu_accessed", next_menu + mode_name)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("configuration_toggled")
