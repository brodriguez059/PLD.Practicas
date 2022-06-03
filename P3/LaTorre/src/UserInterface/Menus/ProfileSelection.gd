extends Transitionable

var save_files
var current_create_profile_index : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.visible = false
	save_files = $NinePatchRect/NinePatchRect/VBoxContainer

## Configuration menu needs to be seen
func _on_BttnConfiguracion_pressed() -> void:
	emit_signal("toggle_configuration")

## Profile selection menu exitted to main menu
func _on_BttnRegresar_pressed() -> void:
	emit_signal("goto_prev_scene", prev_scene, true)
	
## Profile selected button, go to profile view
func _on_Save_pressed_profile_name(index) -> void:
	Global.profile = save_files.get_child(index).profile_data
	emit_signal("goto_next_scene", next_scene, true)

func _on_Save_pressed_create_profile(index) -> void:
	current_create_profile_index = index
	$ColorRect/InsertData/NinePatchRect/NombreField.text = ""
	$ColorRect.visible = true
	# Here the other thing must appear

func _on_BttnClose_pressed() -> void:
	current_create_profile_index = -1
	$ColorRect.visible = false
	$ColorRect/InsertData/NinePatchRect/NombreField.text = ""

func _on_BttnAplicar_pressed() -> void:
	# Extraemos la información del perfil que se quiere crear
	var profile_data = Profile_Data.new()
	profile_data.profile_name = $ColorRect/InsertData/NinePatchRect/NombreField.text

	# Creamos el perfil internamente
	var save_file = save_files.get_child(current_create_profile_index)
	save_file.load_profile(profile_data)

	# Toca guardarlo usando global
	SaveFiles.write_profile_data(current_create_profile_index, profile_data)

	# Borramos los datos del editor de nombres
	current_create_profile_index = -1
	$ColorRect.visible = false
	$ColorRect/InsertData/NinePatchRect/NombreField.text = ""
