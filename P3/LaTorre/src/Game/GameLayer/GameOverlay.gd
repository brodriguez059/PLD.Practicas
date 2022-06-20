extends Control

# warning-ignore:unused_signal
signal pause_toggled()
# warning-ignore:unused_signal
signal death_detected()

onready var health_bar = $Resources/Bars/HealthBar
onready var mana_bar = $Resources/Bars/ManaBar

func change_health(value:float) -> void:
	health_bar.value = value
	if value <= 0.0:
		emit_signal("death_detected")

func change_mana(value:float) -> void:
	mana_bar.value = value

func _on_BttnPause_pressed() -> void:
	emit_signal("pause_toggled")
