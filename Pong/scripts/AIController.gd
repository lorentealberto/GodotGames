extends Node
#Nombre de la clase
class_name AIController

#Ruta del nodo 'bola'
export(NodePath) var ball_path
onready var ball:Ball #Nodo 'bola'

var paddle:Paddle #Nodo raqueta

func _ready():
	#Carga el nodo pelota con la ruta que hemos especificado
	ball = get_node(ball_path)
	#Obtiene el nodo padre de este script
	paddle = get_parent()
	
	#Conecta el comportamiento con el objeto padre
	# warning-ignore:return_value_discarded
	paddle.connect("update", self, "calculate_velocity")
	
#Calcula la velocidad que tendrá la pala
func calculate_velocity() -> void:
	"""Si el objeto al que se le añadido este comportamiento no tiene
	un atributo direction, omite la ejecución de este método"""
	if not "direction" in paddle:
		return
	
	"""Se iguala la dirección de la pala a la dirección de la pelota"""
	paddle.direction = Vector2(0, get_ball_direction())

"""Calcula la dirección a la que se moverá la pala dependiendo de la
	posición de la pelota.
	return: 1 si la pala está por encima de la pelota.
			-1 si la pala está por debajo de la pelota.
			0 Si la pala no está cerca de la pelota."""
func get_ball_direction() -> int:
	#Comprueba que la distancia de la pala a la pelota sea inferior a 20
	if abs(paddle.position.y - ball.position.y) > 20:
		#Comprueba que la pala esté por encima de la pelota
		if paddle.position.y < ball.position.y:
			return 1 #Devuelve 1 si está por encima
		else:
			return -1 #Devuelve -1 si está por debajo
	else: #Si la pala no está en el rango de la pelota
		return 0
