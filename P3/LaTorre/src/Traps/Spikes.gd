extends Area2D

func _on_Spikes_body_entered(body: Node) -> void:
	# Spikes are an instadeath
	body.die()
