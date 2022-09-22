extends RigidBody2D

const Animaciones = {
	INFLANDO_GLOBO = "inflando_globo",
	VOLANDO = "volando"
}

const SALTO: int = 35
const VHORIZONTAL: int = 22

var activado: bool = false
var debe_subir: bool = true
var punto_control_actual: Vector2
var puntos_control: Array
var velocidad: int = 0

func _ready() -> void:
	randomize()
	
	$AnimatedSprite.play(Animaciones.INFLANDO_GLOBO)
	puntos_control = get_node("/root/Juego/PuntosControl").get_children()
	_obtener_nuevo_punto_control()

func _process(delta: float) -> void:
	#Movimiento horizontal
	if sqrt(pow(punto_control_actual.x - floor(position.x), 2)) > 15:
		if floor(position.x) < punto_control_actual.x:
			velocidad = 1
			$AnimatedSprite.flip_h = true
		else:
			velocidad = -1
			$AnimatedSprite.flip_h = false
	else:
		velocidad = 0
	
	#Movimiento vertical
	if sqrt(pow(punto_control_actual.y - floor(position.y), 2)) > 1:
		if floor(position.y) < punto_control_actual.y:
			debe_subir = false
		else:
			debe_subir = true
	
	
	if position.distance_to(punto_control_actual) < 5:
		_obtener_nuevo_punto_control()
		
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	var velocidad_x: float
	
	if velocidad == 0:
		velocidad_x = state.get_linear_velocity().x
	else:
		velocidad_x = velocidad * VHORIZONTAL
		
	state.set_linear_velocity(Vector2(velocidad_x , state.get_linear_velocity().y))

func _obtener_nuevo_punto_control() -> void:
	punto_control_actual = puntos_control[randi() % puntos_control.size()].global_position.floor()

func _aletear() -> void:
	$AnimatedSprite.play(Animaciones.VOLANDO)
	apply_central_impulse(Vector2(0, -SALTO))
	$AnimatedSprite.frame = 0


func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		Animaciones.INFLANDO_GLOBO:
			activado = true
			_aletear()


func _on_Timer_timeout():
	if debe_subir:
		_aletear()


func _on_Globo_body_entered(body):
	pass
