extends RigidBody2D

const Animaciones = {
	ANDANDO = "andando_",
	VOLANDO = "volando_",
	APARECIENDO = "apareciendo_"
}

const VHORIZONTAL: int = 22
const SALTO: int = 20     

var activado: bool = false
var n_globos: String = "dos_globos"
var velocidad: int = 0


func _process(_delta: float) -> void:
	if activado: #Se comprueba que el personaje esté activado
		velocidad = 0
		#Movimiento horizontal
		if Input.is_action_pressed("mover_derecha"):
			velocidad = 1
			$AnimatedSprite.flip_h = true
		elif Input.is_action_pressed("mover_izquierda"):
			velocidad = -1
			$AnimatedSprite.flip_h = false
		#Aletear
		if Input.is_action_just_pressed("aletear"):
			$AnimatedSprite.play()
			apply_central_impulse(Vector2(0, -SALTO))
			$AnimatedSprite.frame = 0
		#Comprobar que se esté tocando el suelo
		if $RayCast2D.is_colliding() and $RayCast2D.get_collider().name == "Suelo":
			$AnimatedSprite.animation = Animaciones.ANDANDO + n_globos
			$AnimatedSprite.playing = (Input.is_action_pressed("mover_derecha") or 
										Input.is_action_pressed("mover_izquierda"))
		else:
			$AnimatedSprite.animation = Animaciones.VOLANDO + n_globos
	else: #Si el personaje no está activado
		#Si alguno de los controles ha sido pulsado, se activa el personaje
		if (Input.is_action_just_pressed("mover_derecha") or
			Input.is_action_just_pressed("mover_izquierda") or
			Input.is_action_just_pressed("aletear")):
				activado = true
		#Poner la animación de 'apareciendo'
		$AnimatedSprite.animation = Animaciones.APARECIENDO + n_globos

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.set_linear_velocity(Vector2(velocidad * VHORIZONTAL, state.get_linear_velocity().y))
