extends KinematicBody2D

export(float) var velocidad_horizontal

var velocidad:Vector2

func _physics_process(delta):
	if not is_on_floor():
		velocidad.y += 1500 * delta
	else:
		velocidad.y = 0
		
	velocidad.x = velocidad_horizontal * delta
	
	velocidad = move_and_slide_with_snap(velocidad, Vector2.DOWN, Vector2.UP)
	
	if position.x <= 0 or position.x >= get_viewport_rect().size.x:
		velocidad_horizontal *= -1
		
	if velocidad_horizontal < 0:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
