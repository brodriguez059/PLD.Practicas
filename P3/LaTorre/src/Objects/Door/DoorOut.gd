extends Area2D

# warning-ignore:unused_signal
signal door_opened(player)

var inside : bool = false

var body = null

func _ready() -> void:
	$ButtonLabel.hide()
	inside = false

func _process(_delta: float) -> void:
	if inside and Input.is_action_pressed("accept"):
		$AnimationPlayer.play("Open")
		emit_signal("door_opened", body)
		$AnimationPlayer.play("Close")

func _on_DoorOut_body_entered(_body: Node) -> void:
	inside = true
	body = _body
	$ButtonLabel.show()
	
func _on_DoorOut_body_exited(_body: Node) -> void:
	inside = false
	body = null
	$ButtonLabel.hide()
