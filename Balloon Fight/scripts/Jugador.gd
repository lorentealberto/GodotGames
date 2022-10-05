extends RigidBody2D
class_name Jugador

#Ajustes
const Animaciones: Dictionary = {
	IDLE = "idle",
	ANDANDO = "andando",
	VOLANDO = "volando",
	PLANEANDO = "planeando",
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
var _playback_maquina_estados: AnimationNodeStateMachinePlayback


func _ready() -> void:
	_playback_maquina_estados = $AnimationTree.get("parameters/playback")


"""Se ejecuta una vez cada frame del juego
_delta: float -> Tiempo en MS que ha transcurrido desde la última vez que se ejecutó el método"""
func _process(_delta: float) -> void:
	if _activado and not _esta_muriendo():
		# -- CONTROLES --
		# Movimiento horizontal
		_direccion = 0
		if Input.is_action_pressed("mover_derecha"):
			_direccion = Direcciones.DERECHA
			$Sprite.flip_h = true
		elif Input.is_action_pressed("mover_izquierda"):
			_direccion = Direcciones.IZQUIERDA
			$Sprite.flip_h = false
		# -- ANIMACIONES --
		# Cambiar animaciones en tierra
		if $RayCast2D.is_colliding():
			_playback_maquina_estados.travel(Animaciones.IDLE + _get_n_globos())
			if (Input.is_action_pressed("mover_derecha") or Input.is_action_pressed("mover_izquierda")):
				_playback_maquina_estados.travel(Animaciones.ANDANDO + _get_n_globos())
			elif floor(linear_velocity.x) != 0:
				_playback_maquina_estados.travel(Animaciones.FRENANDO + _get_n_globos())
			if sign(linear_velocity.x) != _direccion and _direccion != 0:
				_playback_maquina_estados.travel(Animaciones.DERRAPANDO + _get_n_globos())
		# -- CONTROLES / ANIMACIONES --
		# Movimiento vertical
		if Input.is_action_just_pressed("aletear"):
			_playback_maquina_estados.travel(Animaciones.VOLANDO + _get_n_globos())
			apply_central_impulse(Vector2(0, -Velocidades.SALTO))
		elif not $RayCast2D.is_colliding():
			_playback_maquina_estados.travel(Animaciones.PLANEANDO + _get_n_globos())
	else:
		_activado = (Input.is_action_just_pressed("aletear") or
				Input.is_action_just_pressed("mover_derecha") or
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
	return _playback_maquina_estados.get_current_node() in [Animaciones.PERDIENDO_VIDA_AIRE, Animaciones.PERDIENDO_VIDA_SUELO]


"""Devuelve true o false si se está reproduciendo la animación de muerte
return si se está reproduciendo la animación de muerte"""
func _esta_muriendo() -> bool:
	return _playback_maquina_estados.get_current_node() == Animaciones.MURIENDO


"""Devuelve la animación correspondiente en función de si el personaje está en el aire, en el suelo
		o por el contrario si está muriendo.
return animación correspondiente según la situación"""
func _explotar_globo() -> String:
	if _vidas <= 0:
		return Animaciones.MURIENDO
		
	if not $RayCast2D.is_colliding():
		return Animaciones.PERDIENDO_VIDA_AIRE
	#elif $RayCast2D.get_collider().name == SUELO:
	#	return Animaciones.PERDIENDO_VIDA_SUELO
	
	return ""


"""Comprueba si algún cuerpo ha entrado en el área del globo
body: Node -> Cuerpo que se quiere comprobar"""
func _on_Globos_body_entered(body: Node) -> void:
	if body.is_in_group("enemigos"):
		if _vidas > 0:
			_vidas -= 1
		_playback_maquina_estados.travel(_explotar_globo())

