extends Control


# Declare member variables here. Examples:
export(float) var fade_in_duration = 0.3
export(float) var fade_out_duration = 0.2

onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # TODO Buscar una forma de animar el inicio

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func close():
	# Tween's interpolate_property has these arguments:
	# (Target object, "Property:OptionalSubProperty", From value, To value,
	# Tween duration, Transition type, Easing type, Optional delay)
	tween.interpolate_property(self, "modulate:a", 1.0, 0.0, fade_out_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func open():
	show()
	tween.interpolate_property(self, "modulate:a", 0.0, 1.0, fade_in_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _on_BttnInicio_pressed() -> void:
	print("Siguiente interfaz")
	close()
	pass # Replace with function body.

func _on_BttnConfiguracion_pressed() -> void:
	print("Interfaz de configuración")
	close()
	# Se debe ejecutar una animación
	pass # Replace with function body.

func _on_BttnSalir_pressed() -> void:
	# Se debe ejecutar una animación
	close()
	get_tree().quit() # Eliminamos todo el árbol de nodos

func _on_Tween_tween_all_completed() -> void:
	if modulate.a < 0.5:
		hide()
