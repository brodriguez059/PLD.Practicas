extends GameMenu

onready var name_field = $ColorRect/InsertData/NinePatchRect/NombreField
onready var save_files = $NinePatchRect/NinePatchRect/VBoxContainer
onready var opacity_rect = $ColorRect

var current_create_profile_index : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opacity_rect.hide()

# Auxiliary functions
func clear_partial_profile_data() -> void:
	name_field.text = ""
	current_create_profile_index = -1

## Profile selected button, go to profile view

func _on_pressed_create_profile(index) -> void:
	emit_signal("button_fx_played")
	clear_partial_profile_data()
	current_create_profile_index = index
	opacity_rect.show()

func _on_pressed_profile_name(index) -> void:
	emit_signal("button_fx_played")
	Global.set_profile(save_files.get_child(index).profile_data, index)
	emit_signal("next_menu_accessed", next_menu)


# New name menu signals
func _on_BttnClose_pressed() -> void:
	emit_signal("button_fx_played")
	opacity_rect.hide()
	clear_partial_profile_data()

func _on_BttnAplicar_pressed() -> void:
	emit_signal("button_fx_played")

	# Extraemos la información del perfil que se quiere crear
	var profile_data = Profile_Data.new()
	profile_data.profile_name = name_field.text

	# Creamos el perfil internamente
	var save_file = save_files.get_child(current_create_profile_index)
	save_file.load_profile(profile_data)

	# Toca guardarlo usando global
	Global.write_profile(profile_data, current_create_profile_index)

	# Borramos los datos del editor de nombres
	opacity_rect.hide()
	clear_partial_profile_data()


# UI signal emitters

## Configuration menu needs to be seen
func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("configuration_toggled")

## Profile selection menu exitted to main menu
func _on_BttnRegresar_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("prev_menu_accessed", prev_menu)

func _on_button_fx_played() -> void:
	emit_signal("button_fx_played")
