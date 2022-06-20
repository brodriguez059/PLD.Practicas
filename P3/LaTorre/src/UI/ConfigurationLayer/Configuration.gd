extends CanvasLayer

# warning-ignore:unused_signal
signal configuration_toggled()

onready var configuration_node = $Configuration
onready var master_slider = $Configuration/ConfBack/SliderBack/Sliders/Master/MasterSlider
onready var music_slider = $Configuration/ConfBack/SliderBack/Sliders/Music/MusicSlider
onready var fx_slider = $Configuration/ConfBack/SliderBack/Sliders/Fx/FxSlider
onready var button_stream = $ButtonFx

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_slider.value = Global.configuration.master_volume
	music_slider.value = Global.configuration.music_volume
	fx_slider.value = Global.configuration.fx_volume
	configuration_node.hide()

func toggle_configuration() -> void:
	configuration_node.visible = not configuration_node.visible

# Volume configuration changes
func _on_MasterSlider_value_changed(value: float) -> void:
	SoundHandler.set_master_volume(value)
	Global.configuration.master_volume = value

func _on_MusicSlider_value_changed(value: float) -> void:
	SoundHandler.set_music_volume(value)
	Global.configuration.music_volume = value

func _on_FxSlider_value_changed(value: float) -> void:
	SoundHandler.set_fx_volume(value)
	Global.configuration.fx_volume = value

# UI signal emitters
func _on_BttnRegresar_pressed() -> void:
	button_stream.stop()
	button_stream.play()
	toggle_configuration()
