extends NinePatchRect
class_name SaveButton

# ignore-warning:unised_signal
signal button_fx_played()
# ignore-warning:unised_signal
signal pressed_create_profile(index)
# ignore-warning:unised_signal
signal pressed_profile_name(index)

export(int) var index = -1

var profile_data : Profile_Data = null

onready var button_add = $BttnAdd
onready var button_delete = $BttnDelete
onready var button_start = $BttnStart
onready var name_label = $LabelFilename

func show_data() -> void:
	button_add.hide()
	button_delete.show()
	button_start.show()
	name_label.text = profile_data.profile_name
	name_label.show()

func hide_data() -> void:
	button_add.show()
	button_delete.hide()
	button_start.hide()
	name_label.hide()
	name_label.text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_profile()
	if not profile_data:
		hide_data()
	else:
		show_data()

func load_profile(prof_data : Profile_Data = null):
	if not prof_data:
		profile_data = Global.read_profile(index)
	if prof_data:
		profile_data = prof_data

	if profile_data: # We show data only if there is any available
		show_data()

func _on_BttnAdd_pressed() -> void:
	emit_signal("button_fx_played")
	emit_signal("pressed_create_profile", index)

func _on_BttnDelete_pressed() -> void:
	emit_signal("button_fx_played")
	hide_data()
	profile_data = null
	Global.delete_profile(index)

func _on_BttnStart_pressed() -> void:
	emit_signal("button_fx_played")
	Global.profile = profile_data
	emit_signal("pressed_profile_name", index)
