extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var min_value
export(int) var max_value
export(int) var value

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgress.set_min(min_value)
	$TextureProgress.set_max(max_value)
	$TextureProgress.set_value(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
