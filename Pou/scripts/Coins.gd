extends TextureRect

onready var label = $Label

func _process(delta):
	label.text = str(Status.coins)
