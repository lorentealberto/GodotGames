extends KinematicBody2D

onready var animated_sprite:AnimatedSprite = $AnimatedSprite
var velocidad_horizontal:float = -500

var velocidad:Vector2

func _physics_process(delta):
	aplicar_gravedad(delta)

	velocidad.x = velocidad_horizontal * delta

	velocidad = move_and_slide_with_snap(velocidad, Vector2.DOWN, Vector2.UP)

	comprobar_bordes_pantalla()

func aplicar_gravedad(delta:float) -> void:
	if not is_on_floor():
		velocidad.y += 1500 * delta
	else:
		velocidad.y = 0

func comprobar_bordes_pantalla() -> void:
	if position.x <= 0 or position.x >= get_viewport_rect().size.x:
		velocidad_horizontal *= -1
	if velocidad_horizontal < 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
