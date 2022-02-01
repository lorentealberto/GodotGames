extends KinematicBody2D
#Nombre de la clase
class_name Ball

#Máximo de toques para alcanzar la velocidad máxima
const MAX_HITCOUNTER:int = 12

var initial_speed:int #Velocidad inicial de la pelota
var speed_commulator:int #VElocidad que se incrementará por cada toque
var speed:int #Actual velocidad de la pelota

var hitcounter:int #Toques que ha habido en esta partida
var direction:Vector2 #Dirección que tiene la pelota

func _ready():
	randomize() #Elige una semilla aleatoria
	#Inicializa las variables básicas de la pelota
	initial_speed = 300 #Velocidad inicial
	speed_commulator = 50 #Velocidad obtenida por toque
	speed = initial_speed #Velocidad por toque

func _physics_process(delta):
	#Mueve y hace que la pelota colisione.
	var collision := move_and_collide(direction * delta )
	#Comprueba si la pelota ha colisionado con algún objeto.
	if collision:
		#Independietemente del objeto con el que haya colisionado la hace rebotar.
		direction = direction.bounce(collision.normal)
		#Si el objeto con el que colisionó la pelota pertenece al grupo de palas
		if collision.collider.is_in_group("paddles"):
			"""Se ajusta la dirección de la pelota en base a la velocidad que tienen la pala con
			la que ha colisionado."""
			var y := direction.y / 2 + collision.collider_velocity.y
			direction = Vector2(direction.x, y).normalized() * (speed + hitcounter * speed_commulator)
			#Si el contador de toques todavía no ha llegado al máximo, se sigue incrementando.
			if hitcounter < MAX_HITCOUNTER:
				hitcounter += 1
			$PaddleHitSound.play() #Se reproduce el sonido de choque contra la pala
		else:
			$WallHitSound.play() #Se reproduce el sonido de choque contra el muro

"""Establece la dirección inicial que tendrá la pelota"""
func set_start_direction() -> void:
	var rnd:int
	if randi() % 10 < 5:
		rnd = 1
	else:
		rnd = -1
	direction = Vector2(rnd, rand_range(-1, 1))
	direction = direction.normalized() * speed
	
"""Reestablece todos los atributos de la pelota
param onlyPosition: True: Si se desean reestablecer todos los valores de la pelota sin generar
					una nueva dirección inicial.
					False: Si se desea reestablecer todos los valores de la pelota y además,
					generar una nueva dirección inicial."""
func reset(onlyPosition:bool) -> void:
	position = Vector2(512, 256)
	direction = Vector2.ZERO
	hitcounter = 0
	if not onlyPosition:
		set_start_direction()
	
