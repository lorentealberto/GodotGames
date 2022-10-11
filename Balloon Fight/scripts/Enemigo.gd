extends RigidBody2D
class_name Enemigo

# Ajustes
const Animaciones: Dictionary = {
	ATERRIZANDO = "aterrizando",
	INFLANDO_GLOBO = "inflando_globo",
	VOLANDO = "volando",
	PARACAIDAS = "desplegando_paracaidas",
	CAYENDO = "cayendo",
}

const Gravedades: Dictionary = {
	ALTA = 1.0,
	NORMAL = 0.25,
	REDUCIDA = 0.125,
}

const Velocidades: Dictionary = {
	SALTO = 4,
	HORIZONTAL = 0.5,
}

const LimitesVelocidad: Dictionary = {
	INFERIOR = -30.0,
	SUPERIOR = 30.0,
}

# Variables necesarias para el correcto funcionamiento del script
# NO TOCAR
var _activado: bool = false
var _debe_subir: bool = false
var _velocidad: int = 0
var _playback_maquina_estados: AnimationNodeStateMachinePlayback

# Se ejecuta cuando el script esté preparado
func _ready() -> void:
	randomize() # Aplica una semilla aleatoria a la generación de números aleatorios
	_playback_maquina_estados = $AnimationTree.get("parameters/playback")
	_activar()
	

"""Se ejecuta todos los frames del juego
_delta: float -> Tiempo en MS que ha transcurrido desde la última vez que se
llamó a este método."""
func _process(_delta: float) -> void:
	if _activado:
		"""En caso de intentar abandonar la pantalla por los lados
		hace aparecer el objeto por lado contrario de la pantalla"""
		if position.x < 0:
			position.x = get_viewport_rect().size.x
		elif position.x > get_viewport_rect().size.x:
			position.x = 0
		# Impide que el objeto se quede atascado en el suelo y le obliga a subir
		if $RayCast2D.is_colliding():
			_debe_subir = true
	else:
		# Si el objeto no está activado y está tocando el suelo
		if $RayCast2D.is_colliding():
			if _esta_cayendo():
				queue_free()
			elif _en_paracaidas():
				_playback_maquina_estados.travel(Animaciones.INFLANDO_GLOBO)
				_activar()


"""Sobrescribe las físicas que controlan al objeto
state: Physics2DDirectBodyState -> Objeto en sí mismo"""
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if _activado:
		# Impide al objeto salir por la parte superior de la pantalla.
		if $Globo.global_position.y <= 0:
			position.y = 0
			state.linear_velocity.y = 0
			_debe_subir = false
		
		state.set_linear_velocity(Vector2(state.get_linear_velocity().x + _velocidad * Velocidades.HORIZONTAL, 
				state.get_linear_velocity().y))
		
		# Aplicar límites a la velocidad
		if state.linear_velocity.x < LimitesVelocidad.INFERIOR:
			state.linear_velocity.x = LimitesVelocidad.INFERIOR
		elif state.linear_velocity.x > LimitesVelocidad.SUPERIOR:
			state.linear_velocity.x = LimitesVelocidad.SUPERIOR


# Aplica un impulso hacía arriba
func _aletear() -> void:
	_playback_maquina_estados.travel(Animaciones.VOLANDO)
	apply_central_impulse(Vector2(0, -Velocidades.SALTO))


# Devuelve si se está reproduciendo la animación de 'CAYENDO'
func _esta_cayendo() -> bool:
	return _playback_maquina_estados.get_current_node() == Animaciones.CAYENDO


# Devuelve si se está reproduciendo la animació de 'PARACAIDAS'
func _en_paracaidas() -> bool:
	return _playback_maquina_estados.get_current_node() == Animaciones.PARACAIDAS

"""Activa el objeto y da un impulso inicial"""
func _activar() -> void:
	yield(get_tree().create_timer($AnimationPlayer.get_animation(Animaciones.INFLANDO_GLOBO).length), "timeout")
	gravity_scale = Gravedades.NORMAL
	_activado = true
	_aletear()


"""Recoge la señal body_entered del nodo 'Area2D' del objeto
body: Node -> Objeto que entra dentro del área"""
func _on_Globo_body_entered(body: Node) -> void:
	if body is Jugador:
		"""Se realiza una acción diferente dependiendo de la animación que se esté
		reproduciendo actualmente"""
		match _playback_maquina_estados.get_current_node():
			Animaciones.INFLANDO_GLOBO:
				queue_free()
			Animaciones.PARACAIDAS:
				_playback_maquina_estados.travel(Animaciones.CAYENDO)
				gravity_scale = Gravedades.ALTA
			_:
				_playback_maquina_estados.travel(Animaciones.PARACAIDAS)
				_activado = false
				gravity_scale = Gravedades.REDUCIDA


# Recoge la señal screen_exited del nodo 'VisibilityNotifier2D'
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


# Recoge la señal timeout del nodo 'Aleteo'
func _on_Aleteo_timeout():
	if _activado:
		if _debe_subir:
			_aletear()
		else:
			_playback_maquina_estados.travel(Animaciones.ATERRIZANDO)


# Recoge la señal timeout del nodo 'Accion'
func _on_Accion_timeout():
	if _activado:
		"""Se escoge un número aleatorio entre 1 y 2 para determinar la acción
		horizontal que se realizará"""
		if randi() % 2 == 0:
			_velocidad = 1
			$Sprite.flip_h = true
		else:
			_velocidad = -1
			$Sprite.flip_h = false
		
		"""Se indica al objeto si debe subir o no, en función de un número aleatorio
		entre 1 y 2"""
		_debe_subir = randi() % 2 == 0
	
	
