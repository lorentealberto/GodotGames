extends Area2D

export(bool) var estatica

const VELOCIDAD_HORIZONTAL:float = -25.0

func _ready():
	if not estatica:
		$AnimatedSprite.play("encendida")
	else:
		$AnimatedSprite.play("apagada")

func _physics_process(delta):
	if not estatica:
		position.x += VELOCIDAD_HORIZONTAL * delta
		reiniciar_posicion()

func reiniciar_posicion() -> void:
	if position.x < 0:
		position.x = get_viewport_rect().size.x
