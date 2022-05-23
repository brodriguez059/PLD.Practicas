extends Control


# Declare member variables here. Examples:
export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Read the player data
	pass # TODO Buscar una forma de animar el inicio

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_BttnInicio_pressed() -> void:
	# TODO: Deberías añadir alguna animación de cambio
	get_tree().change_scene("res://src/UserInterface/Menus/ProfileSelection.tscn")

func _on_BttnConfiguracion_pressed() -> void:
	# TODO: Deberías añadir alguna animación de cambio
	# TODO: Guarda de cuál interfaz vienes para poder volver de la configuración
	Global.return_scene = "res://src/UserInterface/Menus/MainTitle.tscn"
	get_tree().change_scene("res://src/UserInterface/Menus/Configuration.tscn")
	# Se debe ejecutar una animación

func _on_BttnSalir_pressed() -> void:
	# Se debe ejecutar una animación
	get_tree().quit() # Eliminamos todo el árbol de nodos
