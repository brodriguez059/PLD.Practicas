extends GameMenu

onready var nombre_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileData/VBoxContainer/NombreData
onready var n_plays_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NPlaysData
onready var n_wins_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NWinsData
onready var n_loses_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NLosesData
onready var ratio_wl_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/RatioWLData
onready var n_kills_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NKillsData
onready var n_objects_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NObjectsData
onready var n_enemies_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NEnemiesData
onready var n_vendors_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NVendorsData
onready var n_traps_data = $NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NTrapsData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nombre_data.text = Global.profile.profile_name
	n_plays_data.text = str(Global.profile.number_of_plays)
	n_wins_data.text = str(Global.profile.number_of_wins)
	n_loses_data.text = str(Global.profile.number_of_loses)
	ratio_wl_data.text = str(Global.profile.ratio_win_lose)
	n_kills_data.text = str(Global.profile.number_of_kills)
	n_objects_data.text = str(Global.profile.encountered_objects)
	n_enemies_data.text = str(Global.profile.encountered_enemies)
	n_vendors_data.text = str(Global.profile.encountered_vendors)
	n_traps_data.text = str(Global.profile.encountered_traps)

func _on_BttnRegresar_pressed() -> void:
	emit_signal("button_fx_played")

	# Se guarda el perfil porque ahora deja de estar activo
	if Global.profile:
		Global.write_profile(Global.profile, Global.profile_index)

	# Limpiamos el perfil activo
	Global.clear_profile()
	emit_signal("prev_menu_accessed", prev_menu)

func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("configuration_toggled")

func _on_BttnJugar_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("next_menu_accessed", next_menu)
	
