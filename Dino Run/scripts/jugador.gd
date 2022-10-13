extends RigidBody2D

# AJUSTES
const Animaciones: Dictionary = {
	IDLE = "idle",
	ANDAR = "andar",
	AGACHARSE = "agacharse",
	MORIR = "morir",
}

const SALTO: float = -130.0

# VARIABLES DEL SISTEMA
var _maquina_estados: AnimationNodeStateMachinePlayback

"""Se ejecuta una única vez cuando el script está listo."""
func _ready() -> void:
	_maquina_estados = $AnimationTree.get("parameters/playback")


"""Se ejecuta de manera cíclica todos los framesd del juego.
Parámetros:
	delta: float -> Tiempo en MS que ha transcurrido desde la última vez que se ejecutó esté método."""
func _process(_delta: float) -> void:
	# Control de animaciones
	if $RayCast2D.is_colliding():
		_maquina_estados.travel(Animaciones.ANDAR)
	else:
		_maquina_estados.travel(Animaciones.IDLE)

	# Control de agacharse
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		_maquina_estados.travel(Animaciones.AGACHARSE)
		$DePie.set_deferred("disabled", true)
		$Tumbado.set_deferred("disabled", false)
	else:
		$DePie.set_deferred("disabled", false)
		$Tumbado.set_deferred("disabled", true)


"""Controla el input del ratón.
	event: InputEvent -> Evento que se ha producido."""
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and $RayCast2D.is_colliding():
		match event.button_index:
			BUTTON_LEFT:
				apply_central_impulse(Vector2(0, SALTO))
