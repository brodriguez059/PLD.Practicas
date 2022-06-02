extends NinePatchRect
class_name SaveButton

export(int) var index 
var profile_data : Profile_Data = null

signal pressed_create_profile(index)
signal pressed_profile_name(index)

func show_data() -> void:
	$BttnAdd.visible = false
	$BttnDelete.visible = true
	$BttnStart.visible = true
	$LabelFilename.text = profile_data.profile_name
	$LabelFilename.visible = true

func hide_data() -> void:
	$BttnAdd.visible = true
	$BttnDelete.visible = false
	$BttnStart.visible = false
	$LabelFilename.visible = false
	$LabelFilename.text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_profile()
	if not profile_data:
		hide_data()
	else:
		show_data()

func load_profile(prof_data : Profile_Data = null):
	if not prof_data:
		profile_data = SaveFiles.read_profile_data(index)
	if prof_data:
		profile_data = prof_data

	if profile_data: # We show data only if there is any available
		show_data()

func _on_BttnAdd_pressed() -> void:
	emit_signal("pressed_create_profile", index)

func _on_BttnDelete_pressed() -> void:
	hide_data()
	profile_data = null
	SaveFiles.delete_profile_data(index)

func _on_BttnStart_pressed() -> void:
	Global.profile = profile_data
	emit_signal("pressed_profile_name", index)
