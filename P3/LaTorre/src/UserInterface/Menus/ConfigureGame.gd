extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_BttnRegresar_pressed() -> void:
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/ProfileView.tscn")

func _on_BttnConfiguracion_pressed() -> void:
	Global.return_scene = "res://src/UserInterface/Menus/ConfigureGame.tscn"
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/Configuration.tscn")

func _on_BttnCreateGame_pressed() -> void:
	#TODO: No olvides mandar la info de la partida nueva al selector de personajes
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/CharacterSelection.tscn")
