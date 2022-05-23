extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_BttnRegresar_pressed() -> void:
	get_tree().change_scene("res://src/UserInterface/Menus/ProfileView.tscn")

func _on_BttnConfiguracion_pressed() -> void:
	Global.return_scene = "res://src/UserInterface/Menus/ConfigureGame.tscn"
	get_tree().change_scene("res://src/UserInterface/Menus/Configuration.tscn")

func _on_BttnCreateGame_pressed() -> void:
	#TODO: No olvides mandar la info de la partida nueva al selector de personajes
	get_tree().change_scene("res://src/UserInterface/Menus/CharacterSelection.tscn")
