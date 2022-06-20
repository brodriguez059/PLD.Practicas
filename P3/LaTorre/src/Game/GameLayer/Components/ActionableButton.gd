extends NinePatchRect

signal activate_action(metadata)

onready var tween = $Tween
onready var cooldown_progress = $CenterContainer/CooldownBar
onready var button_action = $CenterContainer/BttnAction

var metadata = null

func _ready() -> void:
	cooldown_progress.hide()
	cooldown_progress.value = 0

func _on_BttnAction_pressed() -> void:
	button_action.disabled = true
	emit_signal("activate_action", metadata)
	cooldown_progress.show()
	tween.interpolate_property(cooldown_progress, "value",
		0, 100, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
	tween.start()

func _on_Tween_tween_all_completed() -> void:
	cooldown_progress.hide()
	cooldown_progress.value = 0
	button_action.disabled = false
