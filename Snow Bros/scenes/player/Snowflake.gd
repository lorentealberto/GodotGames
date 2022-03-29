extends Area2D
class_name Snowflake #Nombre de la clase

const FRICTION:float = 3.5 #Fricción del objeto

var hspeed:float #Velocidad horizontal
var apply_gravity:bool #Si se tiene que aplicar la gravedad o no

"""Inicializa los valores iniciales del objeto"""
func _ready():
	apply_gravity = false
	hspeed = 150.0

"""Función que se ejecuta todos los frames del juego
	delta: Tiempo en MS desde que se llamó a esta función por última vez"""
func _process(delta):
	position.x += hspeed * delta
	slowdown()
	
	#Aplica la gravedad al objeto si la bandera de la gravedad está activada
	if apply_gravity:
		position.y += Settings.WORLD_GRAVITY / 5 * delta

"""Aumenta la velocidad del objeto en base a la velocidad del objeto padre.
	parent_speed: Velocidad del objeto padre"""
func relativity(parent_speed:float) -> void:
	hspeed += parent_speed

"""Establece la dirección del objeto en base al valor del parámetro.
	go_right: Dirección a la que irá el objeto."""
func set_direction(go_right:bool) -> void:
	$AnimatedSprite.flip_h = go_right
	if not go_right:
		hspeed *= -1

"""Mientras que la velocidad del objeto sea igual o menor que cero, se reducirá su velocidad"""
func slowdown() -> void:
	if hspeed > 0:
		hspeed -= FRICTION
	else:
		hspeed += FRICTION

"""Evento que se dispara cada vez que este objeto ha entrado en algún cuerpo.
	body: Cuerpo en el que ha entrado este objeto."""
func _on_Snowflake_body_entered(body):
	if body.name != "Player":
		if body is Enemy:
			queue_free()
			body.cover()
		else:
			queue_free()

"""Evento que se dispara cuando se ha acabado el temporizador del objeto."""
func _on_Timer_timeout():
	apply_gravity = true

"""Evento que se dispara cuando el objeto no está en la pantalla"""
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
