extends TextureRect

onready var bg_color = $"Background Color"
const MAX = 100

var current = 0

func _process(delta):

	bg_color.rect_size.y = current * 58 / 100
	
	if current > 75:
		bg_color.color = Color("#a3ef7d")
	elif current <= 75 and current >= 25:
		bg_color.color = Color("#ebef7d")
	elif current < 25:
		bg_color.color = Color("#f05d2a")
		
	if current < 0:
		current = 0
	if current > MAX:
		current = MAX
