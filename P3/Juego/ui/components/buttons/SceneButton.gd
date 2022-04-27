extends Button

export(String) var target_scene
export(String) var label_text

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button/Label.set_text(label_text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
