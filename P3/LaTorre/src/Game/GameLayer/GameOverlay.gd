extends Control

# warning-ignore:unused_signal
signal pause_toggled()

onready var health_bar = $Resources/Bars/HealthBar
onready var mana_bar = $Resources/Bars/ManaBar

func change_health(value:float) -> void:
	health_bar.value = value

func change_mana(value:float) -> void:
	mana_bar.value = value

func _on_BttnPause_pressed() -> void:
	emit_signal("pause_toggled")
