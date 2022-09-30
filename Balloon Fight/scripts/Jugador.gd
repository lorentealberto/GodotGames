extends RigidBody2D
class_name Jugador

#Ajustes
const Animaciones: Dictionary = {
	ANDANDO = "andando",
	VOLANDO = "volando",
	APARECIENDO = "apareciendo",
	FRENANDO = "frenando",
	DERRAPANDO = "derrapando",
	PERDIENDO_VIDA_AIRE = "perdiendo_vida_aire",
	PERDIENDO_VIDA_SUELO = "perdiendo_vida_suelo",
	MURIENDO = "muriendo",
}

const Velocidades: Dictionary = {
	SALTO = 20.0,
	HORIZONTAL = 0.5,
}

const LimitesVelocidad: Dictionary = {
	INFERIOR = -30.0,
	SUPERIOR = 30.0,
}

const NGlobos: Array = ["_un_globo", "_dos_globos"]
const SUELO: String = "Suelo"

const Direcciones: Dictionary = {
	DERECHA = 1,
	IZQUIERDA = -1,
}

const VIDAS_MAXIMAS: int = 2

# Variables necesarias para el correcto funcionamiento del script
# NO TOCAR
var _activado: bool = false
var _direccion: int = 0
var _vidas: int = 2
var _animacion_bloqueada: bool = false

"""Se ejecuta cuando el método está listo"""
func _ready() -> void:
	$AnimatedSprite.play(Animaciones.APARECIENDO + _get_n_globos())


"""Se ejecuta una vez cada frame del juego
_delta: float -> Tiempo en MS que ha transcurrido desde la última vez que se ejecutó el método"""
func _process(_delta: float) -> void:
	if _activado:
		# Movimiento horizontal
		_direccion = 0
		if not _esta_muriendo():
			if Input.is_action_pressed("mover_derecha"):
				_direccion = Direcciones.DERECHA
				$AnimatedSprite.flip_h = true
			elif Input.is_action_pressed("mover_izquierda"):
				_direccion = Direcciones.IZQUIERDA
				$AnimatedSprite.flip_h = false
			
			# Aleteo
			if Input.is_action_just_pressed("aletear"):
				if not _animacion_bloqueada:
					$AnimatedSprite.play()
				apply_central_impulse(Vector2(0, -Velocidades.SALTO))
				$AnimatedSprite.frame = 0

		# Está en suelo
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().name == SUELO and not _animacion_bloqueada:
			# Andando
			$AnimatedSprite.animation = Animaciones.ANDANDO + _get_n_globos()
			
			# Frenando
			if floor(linear_velocity.x) != 0 and _direccion == 0:
				$AnimatedSprite.animation = Animaciones.FRENANDO + _get_n_globos()
			
			# Derrapando
			if sign(linear_velocity.x) != _direccion and _direccion != 0:
				$AnimatedSprite.animation = Animaciones.DERRAPANDO + _get_n_globos()
			
			# Si se está pulsando algún control horizontal
			$AnimatedSprite.playing = (Input.is_action_pressed("mover_derecha") or 
					Input.is_action_pressed("mover_izquierda"))
		else:
			if not _animacion_bloqueada: # Si no está en el suelo y la animación no está bloqueada
				$AnimatedSprite.animation = Animaciones.VOLANDO + _get_n_globos()
	else: # En caso de que el personaje esté desactivado, activarlo al pulsar algún control
		_activado = (Input.is_action_just_pressed("aletear") or Input.is_action_just_pressed("mover_derecha") or
				Input.is_action_just_pressed("mover_izquierda"))


"""Sobrescribe las físicas que controlan al objeto
state: Physics2DDirectBodyState -> Objeto en sí mismo"""
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.set_linear_velocity(Vector2(state.get_linear_velocity().x + _direccion * Velocidades.HORIZONTAL, 
			state.get_linear_velocity().y))
		
	# Aplicar límites a la velocidad
	if state.linear_velocity.x < LimitesVelocidad.INFERIOR:
		state.linear_velocity.x = LimitesVelocidad.INFERIOR
	elif state.linear_velocity.x > LimitesVelocidad.SUPERIOR:
		state.linear_velocity.x = LimitesVelocidad.SUPERIOR


"""Devuelve la animación correspondiente al número de vidas que tenga el jugador
return nombre de la animación"""
func _get_n_globos() -> String:
	return NGlobos[_vidas - 1]


"""Devuelve true o false si se está reproduciendo la animación de 'perdiendo_vida'
return si se está perdiendo una vida"""
func _perdiendo_globo() -> bool:
	return $AnimatedSprite.animation in [Animaciones.PERDIENDO_VIDA_AIRE, Animaciones.PERDIENDO_VIDA_SUELO]


"""Devuelve true o false si se está reproduciendo la animación de muerte
return si se está reproduciendo la animación de muerte"""
func _esta_muriendo() -> bool:
	return $AnimatedSprite.animation == Animaciones.MURIENDO


"""Devuelve la animación correspondiente en función de si el personaje está en el aire, en el suelo
		o por el contrario si está muriendo.
return animación correspondiente según la situación"""
func _explotar_globo() -> String:
	if _vidas <= 0:
		return Animaciones.MURIENDO
		
	if not $RayCast2D.is_colliding():
		return Animaciones.PERDIENDO_VIDA_AIRE
	elif $RayCast2D.get_collider().name == SUELO:
		return Animaciones.PERDIENDO_VIDA_SUELO
	
	return ""


"""Comprueba si algún cuerpo ha entrado en el área del globo
body: Node -> Cuerpo que se quiere comprobar"""
func _on_Globos_body_entered(body: Node) -> void:
	if body.is_in_group("enemigos"):
		if _vidas > 0:
			_vidas -= 1
		$AnimatedSprite.play(_explotar_globo())
		_animacion_bloqueada = true


"""Señal automática que envía el nodo 'AnimatedSprite' cuando alguna animación ha terminado de
reproducirse"""
func _on_AnimatedSprite_animation_finished():
	if _perdiendo_globo():
		_animacion_bloqueada = false
