extends Area2D

export(bool) var estatico

const VELOCIDAD_HORIZONTAL:float = -25.0

func _physics_process(delta):
	if not estatico:
		position.x += VELOCIDAD_HORIZONTAL * delta
		reiniciar_posicion()

func reiniciar_posicion() -> void:
	if position.x < 0:
		position.x = get_viewport_rect().size.x
