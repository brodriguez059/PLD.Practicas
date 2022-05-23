extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var current_create_profile_index : int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ColorRect.visible = false
	$NinePatchRect/NinePatchRect/VBoxContainer/Save1.load_profile()
	$NinePatchRect/NinePatchRect/VBoxContainer/Save2.load_profile()
	$NinePatchRect/NinePatchRect/VBoxContainer/Save3.load_profile()

func _on_BttnConfiguracion_pressed() -> void:
	Global.return_scene = "res://src/UserInterface/Menus/ProfileSelection.tscn"
	get_tree().change_scene("res://src/UserInterface/Menus/Configuration.tscn")

func _on_BttnRegresar_pressed() -> void:
	get_tree().change_scene("res://src/UserInterface/Menus/MainTitle.tscn")

func _on_Save_pressed_create_profile(index) -> void:
	current_create_profile_index = index
	$ColorRect/InsertData/NinePatchRect/NombreField.text = ""
	$ColorRect.visible = true
	# Here the other thing must appear

func _on_BttnClose_pressed() -> void:
	current_create_profile_index = -1
	$ColorRect.visible = false
	$ColorRect/InsertData/NinePatchRect/NombreField.text = ""
	
func get_save_file(index) -> SaveButton:
	var save_file = null
	match current_create_profile_index:
		0:
			save_file = $NinePatchRect/NinePatchRect/VBoxContainer/Save1
		1:
			save_file = $NinePatchRect/NinePatchRect/VBoxContainer/Save2
		2:
			save_file = $NinePatchRect/NinePatchRect/VBoxContainer/Save3
	return save_file

func _on_BttnAplicar_pressed() -> void:
	# Extraemos la información del perfil que se quiere crear
	var profile_name = $ColorRect/InsertData/NinePatchRect/NombreField.text
	var profile_data = Profile_Data.new()
	profile_data.profile_name = profile_name
	# Creamos el perfil internamente
	var save_file = get_save_file(current_create_profile_index)
	save_file.load_profile(profile_data)
	# Toca guardarlo usando global
	Global.profile = profile_data
	Global.store_profile(current_create_profile_index)
	# Restauramos el editor de nombre
	current_create_profile_index = -1
	$ColorRect.visible = false
	$ColorRect/InsertData/NinePatchRect/NombreField.text = ""

func _on_Save_pressed_profile_name(index) -> void:
	get_tree().change_scene("res://src/UserInterface/Menus/ProfileView.tscn")
