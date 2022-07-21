extends RigidBody2D

const VELOCIDAD_HORIZONTAL: float = 40.0

var horizontal: int

enum Estados {INACTIVO, ANDANDO}
var estado_actual: int


func _ready() -> void:
	horizontal = 0
	estado_actual = Estados.INACTIVO

func _process(delta: float) -> void:
	#Máquina de estados
	if horizontal == 0:
		estado_actual = Estados.INACTIVO
	else:
		estado_actual = Estados.ANDANDO
	
	match estado_actual:
		Estados.INACTIVO:
			$AnimatedSprite.play("inactivo")
		Estados.ANDANDO:
			$AnimatedSprite.play("andar")
	
	#Controles
	#Movimiento horizontal
	if Input.is_action_pressed("brutus_derecha"):
		horizontal = 1
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("brutus_izquierda"):
		horizontal = -1
		$AnimatedSprite.flip_h = true
	else:
		horizontal = 0
	
	if horizontal != 0:
		for body in $CuerpoBrutus.get_overlapping_bodies():
			if body.name == "EscalerasHorizontales" and $RayCast2D.is_colliding():
				if Input.is_action_just_pressed("brutus_derecha") or Input.is_action_just_pressed("brutus_izquierda"):
					apply_central_impulse(Vector2.UP * 75)
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.set_linear_velocity(Vector2(horizontal * VELOCIDAD_HORIZONTAL, state.linear_velocity.y))
