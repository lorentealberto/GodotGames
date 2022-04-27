extends Area2D

signal escalando(esta)
onready var gatillo:Area2D = $Area2D
onready var jugador:KinematicBody2D = get_parent().get_node("Jugador")

func _ready():
	connect("area_exited", self, "salio_escalera")
	gatillo.connect("area_entered", self, "piso_gatillo")
	connect("escalando", jugador, "_on_Escalera_escalando")

func piso_gatillo(area):
	if area.name == "CuerpoJugador":
		emit_signal("escalando", true)

func salio_escalera(area):
	if area.name == "CuerpoJugador":
		emit_signal("escalando", false)
