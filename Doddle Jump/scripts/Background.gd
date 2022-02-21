extends Sprite

var texture_height

func _ready():
	texture_height = texture.get_size().y * scale.y

func _physics_process(delta):
	print(position.y)


func _on_VisibilityNotifier2D_screen_exited():
	position.y -= 2 * texture_height
