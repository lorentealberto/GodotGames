extends HBoxContainer

onready var location_label := $"Location Label"

func _ready():
	location_label.text = get_parent().name
