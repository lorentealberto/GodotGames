extends RigidBody2D

# AJUSTES
const Animaciones: Dictionary = {
	IDLE = "idle",
	ANDAR = "andar",
	SALTAR = "saltar",
	CAER = "caer",
	DISPARAR = "disparar",
	MORIR = "morir",
}

const Velocidades: Dictionary = {
	SALTO = -85.0,
	HORIZONTAL = 50.0,
}

const Direcciones: Dictionary = {
	DERECHA = 1,
	IZQUIERDA = -1,
}

# VARIABLES SISTEMA
var _direccion: int = 0
var _playback_maquina_estados: AnimationNodeStateMachinePlayback

"""Se ejecuta una única vez cuando está listo el script"""
func _ready() -> void:
	_playback_maquina_estados = $AnimationTree.get("parameters/playback")


"""Se ejecuta todos los frames del juego
	Parámetros:
		_delta: float -> Tiempo en MS que ha transcurrido desde la última vez que se invocó este método"""
func _process(_delta: float) -> void:
	# Control Movimiento Horizontal
	_direccion = 0
	if Input.is_action_pressed("mover_derecha"):
		_direccion = Direcciones.DERECHA
		$Sprite.flip_h = false
	elif Input.is_action_pressed("mover_izquierda"):
		_direccion = Direcciones.IZQUIERDA
		$Sprite.flip_h = true
	
	# Contro de estados IDLE / ANDAR
	if _direccion != 0:
		_playback_maquina_estados.travel(Animaciones.ANDAR)
	else:
		_playback_maquina_estados.travel(Animaciones.IDLE)
	
	
	# Control Movimiento Vertical
	if Input.is_action_just_pressed("saltar") and $RayCast2D.is_colliding():
		apply_central_impulse(Vector2(0, Velocidades.SALTO))
	
	# Control de estados CAER / SALTAR
	if linear_velocity.y > 0:
		_playback_maquina_estados.travel(Animaciones.CAER)
	elif linear_velocity.y < 0:
		_playback_maquina_estados.travel(Animaciones.SALTAR)


"""Método propio de Godot para sobreescribir las velocidades de un objeto"""
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.linear_velocity.x = _direccion * Velocidades.HORIZONTAL
