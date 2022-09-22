extends RigidBody2D

const Animaciones = {
	INFLANDO_GLOBO = "inflando_globo",
	VOLANDO = "volando",
	PARACAIDAS = "paracaidas",
	CAYENDO = "cayendo"
}

const SALTO: int = 6    
const VHORIZONTAL: int = 22

var activado: bool = false
var debe_subir: bool = false
var punto_control_actual: Vector2
var puntos_control: Array
var velocidad: int = 0

signal sin_paracaidas

func _ready() -> void:
	randomize()
	
	$AnimatedSprite.play(Animaciones.INFLANDO_GLOBO)
	puntos_control = get_node("/root/Juego/PuntosControl").get_children()

func _process(_delta: float) -> void:
	if activado:
		#Movimiento horizontal
		if sqrt(pow(punto_control_actual.x - position.x, 2)) < 10.0:
			velocidad = 0
		else:
			if punto_control_actual.x < position.x:
				velocidad = -1
				$AnimatedSprite.flip_h = false
			elif punto_control_actual.x > position.x:
				velocidad = 1
				$AnimatedSprite.flip_h = true
		#Movimiento vertical
		if sqrt(pow(punto_control_actual.y - position.y, 2)) > 1.0:
			if punto_control_actual.y < position.y:
				debe_subir = true
			else:
				debe_subir = false
		if position.distance_to(punto_control_actual) < 10.0:
			_obtener_nuevo_punto_control()
	else:
		if $RayCast2D.is_colliding():
			if _esta_cayendo():
				queue_free()
			elif _en_paracaidas():
				$AnimatedSprite.play(Animaciones.INFLANDO_GLOBO)

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if activado:
		var velocidad_x: float

		if velocidad == 0:
			velocidad_x = state.get_linear_velocity().x
		else:
			velocidad_x = velocidad * VHORIZONTAL

		state.set_linear_velocity(Vector2(velocidad_x, state.get_linear_velocity().y))

func _obtener_nuevo_punto_control() -> void:
	punto_control_actual = puntos_control[randi() % puntos_control.size()].global_position

func _aletear() -> void:
	$AnimatedSprite.play(Animaciones.VOLANDO)
	apply_central_impulse(Vector2(0, -SALTO))
	$AnimatedSprite.frame = 0

func _esta_cayendo() -> bool:
	return $AnimatedSprite.animation == Animaciones.CAYENDO

func _en_paracaidas() -> bool:
	return $AnimatedSprite.animation == Animaciones.PARACAIDAS

func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		Animaciones.INFLANDO_GLOBO:
			gravity_scale = 0.5
			activado = true
			_obtener_nuevo_punto_control()
			_aletear()

func _on_Timer_timeout():
	if activado and debe_subir and not (_en_paracaidas() or _esta_cayendo()):
		_aletear()

func _on_Globo_body_entered(body):
	if body.name == "Jugador":
		match $AnimatedSprite.animation:
			Animaciones.INFLANDO_GLOBO:
				queue_free()
			Animaciones.VOLANDO:
				$AnimatedSprite.play(Animaciones.PARACAIDAS)
				activado = false
				gravity_scale = 0.25
			Animaciones.PARACAIDAS:
				emit_signal("sin_paracaidas")
				$AnimatedSprite.play(Animaciones.CAYENDO)

func _on_Enemigo_sin_paracaidas() -> void:
	gravity_scale = 1

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
