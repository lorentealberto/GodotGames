extends Sprite

const VELOCITY = 300
var texture_width = texture.get_size().x * scale.x

func _process(delta):
	position.x -= VELOCITY * delta
	reset()

func reset():
	if position.x < -texture_width:
		position.x += 2 * texture_width
