extends KinematicBody2D

export(Texture) var texture

enum STATE_ENUM {NORMAL, BREAKING, GONE}
var state = STATE_ENUM.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if texture:
		$Sprite.texture = texture

func act_upon_collision() -> void:
	
	if state == STATE_ENUM.NORMAL:
		$AnimationPlayer.play("Break")
	elif state == STATE_ENUM.BREAKING:
		$AnimationPlayer.play("Dissappear")
		$Regenerate.start()

func _on_Regenerate_timeout() -> void:
	$AnimationPlayer.play("Regenerate")
