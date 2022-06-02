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

func _on_BttnSelect_pressed() -> void:
	# ESTA ES UNA DE LAS FUNCIONES MÁS IMPORTANTES DE TU JUEGO
	# DESDE AQUÍ SE VA A LA PARTIDA DE VERDAD
	print("Empieza la partida")
	print("Esperando a los demás jugadores...")
	pass # Replace with function body.
	
func _on_BttnRegresar_pressed() -> void:
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/ConfigureGame.tscn")

func _on_BttnConfiguracion_pressed() -> void:
	Global.return_scene = "res://src/UserInterface/Menus/CharacterSelection.tscn"
	var _result = get_tree().change_scene("res://src/UserInterface/Menus/Configuration.tscn")
