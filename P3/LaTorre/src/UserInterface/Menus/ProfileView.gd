extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileData/VBoxContainer/NombreData.text = Global.profile.profile_name
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NPlaysData.text = str(Global.profile.number_of_plays)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NWinsData.text = str(Global.profile.number_of_wins)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NLosesData.text = str(Global.profile.number_of_loses)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/RatioWLData.text = str(Global.profile.ratio_win_lose)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileGameStats/VBoxContainer/NKillsData.text = str(Global.profile.number_of_kills)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NObjectsData.text = str(Global.profile.encountered_objects)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NEnemiesData.text = str(Global.profile.encountered_enemies)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NVendorsData.text = str(Global.profile.encountered_vendors)
	$NinePatchRect/NinePatchRect/HBoxContainer/ProfileCollectorStats/VBoxContainer/NTrapsData.text = str(Global.profile.encountered_traps)	

func _on_BttnRegresar_pressed() -> void:
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/ProfileSelection.tscn")

func _on_BttnConfiguracion_pressed() -> void:
	Global.return_scene = "res://src/UserInterface/Menus/ProfileView.tscn"
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/Configuration.tscn")

func _on_BttnJugar_pressed() -> void:
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/ConfigureGame.tscn")
