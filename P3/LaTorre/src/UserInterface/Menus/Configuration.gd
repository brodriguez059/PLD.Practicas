extends Control

signal toggle_configuration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$NinePatchRect/NinePatchRect/VBoxContainer/MasterContainer/MasterSlider.value = Global.configuration.master_volume
	$NinePatchRect/NinePatchRect/VBoxContainer/MusicContainer/MusicSlider.value = Global.configuration.music_volume
	$NinePatchRect/NinePatchRect/VBoxContainer/FxContainer/FxSlider.value = Global.configuration.fx_volume

func _on_BttnRegresar_pressed() -> void:
	emit_signal("toggle_configuration")

func _on_MasterSlider_value_changed(value: float) -> void:
	Global.configuration.master_volume = value
	print("Máster: " + str(value))

func _on_MusicSlider_value_changed(value: float) -> void:
	Global.configuration.music_volume = value
	print("Música: " + str(value))

func _on_FxSlider_value_changed(value: float) -> void:
	Global.configuration.fx_volume = value
	print("Fx: " + str(value))
