extends Area2D

func _on_Spikes_body_entered(body: Node) -> void:
	# Spikes are an instadeath
	if body is Character:
		body.instadie()
