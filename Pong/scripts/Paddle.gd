extends KinematicBody2D
class_name Paddle #Nombre de la clase

#Señal que se emite cuando se desea actualizar el objeto
signal update

#Datos que tiene este objeto.
var speed:int
var direction:Vector2

func _ready():
	speed = 250
	direction = Vector2.ZERO
	
"""En cada frame del juego, emitir la señal de actualizar este objeto"""
func _process(_delta):
	emit_signal("update")

"""Método que actualiza este objeto de un modo más estable"""
func _physics_process(delta):
	if direction.length() > 0:
		direction = direction.normalized() * speed
		# warning-ignore:return_value_discarded
		move_and_collide(direction * delta)

"""Método que resetea la posición de este objeto"""
func reset() -> void:
	position.y = 256
