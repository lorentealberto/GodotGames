extends Area2D

signal enganchado(esta)

onready var jugador:KinematicBody2D = get_parent().get_node("Jugador")

var angulos_rotacion:int = 75
var velocidad_rotacion:float = 1

var direccion:String = "izquierda"

func _ready():
	connect("area_entered", self, "cogida")
	connect("area_exited", self, "soltada")
	connect("enganchado", jugador, "cogio_escalera")

func _process(_delta):
	match direccion:
		"izquierda":
			rotation_degrees += velocidad_rotacion
		"derecha":
			rotation_degrees -= velocidad_rotacion

	if int(rotation_degrees) >= angulos_rotacion:
		direccion = "derecha"
	if int(rotation_degrees) <= -angulos_rotacion:
		direccion = "izquierda"

func cogida(area:Area2D) -> void:
	if area.name == "CuerpoJugador":
		emit_signal("enganchado", true)

func soltada(area:Area2D) -> void:
	if area.name == "CuerpoJugador":
		emit_signal("enganchado", false)

func obtener_posicion_eslabon(id_eslabon:int) -> Vector2:
	return get_child(id_eslabon).global_position
