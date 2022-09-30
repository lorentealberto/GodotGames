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


func _ready() -> void:
	$AnimatedSprite.play(Animaciones.APARECIENDO + _get_n_globos())
	
func _process(_delta: float) -> void:
	if _activado:
		# Movimiento horizontal
		_direccion = 0
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
			$AnimatedSprite.animation = Animaciones.ANDANDO + _get_n_globos()
			
			if floor(linear_velocity.x) != 0 and _direccion == 0:
				$AnimatedSprite.animation = Animaciones.FRENANDO + _get_n_globos()
			
			if sign(linear_velocity.x) != _direccion and _direccion != 0:
				$AnimatedSprite.animation = Animaciones.DERRAPANDO + _get_n_globos()
			
			$AnimatedSprite.playing = (Input.is_action_pressed("mover_derecha") or 
					Input.is_action_pressed("mover_izquierda"))
		else:
			if not _animacion_bloqueada:
				$AnimatedSprite.animation = Animaciones.VOLANDO + _get_n_globos()
	else:
		_activado = (Input.is_action_just_pressed("aletear") or Input.is_action_just_pressed("mover_derecha") or
				Input.is_action_just_pressed("mover_izquierda"))

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.set_linear_velocity(Vector2(state.get_linear_velocity().x + _direccion * Velocidades.HORIZONTAL, 
			state.get_linear_velocity().y))
		
	# Aplicar límites a la velocidad
	if state.linear_velocity.x < LimitesVelocidad.INFERIOR:
		state.linear_velocity.x = LimitesVelocidad.INFERIOR
	elif state.linear_velocity.x > LimitesVelocidad.SUPERIOR:
		state.linear_velocity.x = LimitesVelocidad.SUPERIOR


func _get_n_globos() -> String:
	return NGlobos[_vidas - 1]

func _perdiendo_globo() -> bool:
	return $AnimatedSprite.animation in [Animaciones.PERDIENDO_VIDA_AIRE, Animaciones.PERDIENDO_VIDA_SUELO]
func _esta_muriendo() -> bool:
	return $AnimatedSprite.animation == Animaciones.MURIENDO
func _explotar_globo() -> String:
	if _vidas <= 0:
		return Animaciones.MURIENDO
		
	if not $RayCast2D.is_colliding():
		return Animaciones.PERDIENDO_VIDA_AIRE
	elif $RayCast2D.get_collider().name == SUELO:
		return Animaciones.PERDIENDO_VIDA_SUELO
	
	return ""


func _on_Globos_body_entered(body: Node) -> void:
	if body.is_in_group("enemigos"):
		$AnimatedSprite.play(_explotar_globo())
		_animacion_bloqueada = true


func _on_AnimatedSprite_animation_finished():
	if _perdiendo_globo():
		if _vidas > 0:
			_vidas -= 1
		_animacion_bloqueada = false
	if _esta_muriendo():
		pass
	
