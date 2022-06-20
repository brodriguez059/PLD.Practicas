extends CanvasLayer

signal transition_end

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("Fade_in")

func start_transition(speed:float = 1.0):
	$AnimationPlayer.playback_speed = speed
	$AnimationPlayer.play("Fade_out")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Fade_out":
		emit_signal("transition_end")
		$AnimationPlayer.play("Fade_in")
	elif anim_name == "Fade_in":
		pass
