extends Control

onready var sprite_box = $CharacterView/CharacterSpriteBox

var max_characters = 0
var current_character_index = 0
var current_character = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_characters = sprite_box.get_child_count()
	current_character = sprite_box.get_child(current_character_index)
	current_character.get_node(@"AnimationPlayer").play("idle")
	current_character.show()
	
func page_audio_play() -> void:
	$ChangePageAudio.stop()
	$ChangePageAudio.play()

func show_character() -> void:
	for character in sprite_box.get_children():
		character.hide()
		character.get_node(@"AnimationPlayer").stop(true)
	
	current_character = sprite_box.get_child(current_character_index)
	current_character.get_node(@"AnimationPlayer").play("idle")
	current_character.show()
	
func get_character_by_index(idx : int):
	match(idx):
		0:
			return {"class":"Archer"}
		1:
			return {"class":"Mage"}
		_:
			return null
	
func get_character():
	return get_character_by_index(current_character_index)

func _on_BttnNext_pressed() -> void:
	page_audio_play()
	current_character_index = (current_character_index + 1) % max_characters
	show_character()

func _on_BttnPrev_pressed() -> void:
	page_audio_play()
	current_character_index = (current_character_index - 1) if (current_character_index > 0) else (max_characters - 1)
	show_character()
