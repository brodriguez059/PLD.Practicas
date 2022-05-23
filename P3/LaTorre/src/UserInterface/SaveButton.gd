extends NinePatchRect
class_name SaveButton

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export(int) var index = 0
var profile_data : Profile_Data = null

signal pressed_create_profile(index)
signal pressed_profile_name(index)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not profile_data:
		$BttnAdd.visible = true
		$BttnDelete.visible = false
		$BttnStart.visible = false
		$LabelFilename.visible = false
		$LabelFilename.text = ""
	else:
		$BttnAdd.visible = false
		$BttnDelete.visible = true
		$BttnStart.visible = true
		$LabelFilename.text = profile_data.profile_name
		$LabelFilename.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func load_profile(profile_data : Profile_Data = null):
	if not profile_data:
		profile_data = Global.read_player_data(index)
	if profile_data:
		$BttnAdd.visible = false
		$BttnDelete.visible = true
		$BttnStart.visible = true
		$LabelFilename.text = profile_data.profile_name
		$LabelFilename.visible = true

func _on_BttnAdd_pressed() -> void:
	emit_signal("pressed_create_profile", index)

func _on_BttnDelete_pressed() -> void:
	$BttnAdd.visible = true
	$BttnDelete.visible = false
	$BttnStart.visible = false
	$LabelFilename.visible = false
	$LabelFilename.text = ""
	profile_data = null
	Global.remove_profile(index)

func _on_BttnStart_pressed() -> void:
	Global.profile = profile_data
	emit_signal("pressed_profile_name", index)
