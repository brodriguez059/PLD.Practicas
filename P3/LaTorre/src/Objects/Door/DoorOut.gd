extends Area2D

# warning-ignore:unused_signal
signal door_opened()

var inside : bool = false

func _ready() -> void:
	$ButtonLabel.hide()
	inside = false

func _process(_delta: float) -> void:
	if inside and Input.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("Open")
		emit_signal("door_opened")
		$AnimationPlayer.play("Close")

func _on_DoorOut_body_entered(_body: Node) -> void:
	inside = true
	$ButtonLabel.show()
	
func _on_DoorOut_body_exited(_body: Node) -> void:
	inside = false
	$ButtonLabel.hide()
