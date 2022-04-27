extends Control

onready var label:Label = $Label
onready var timer:Timer = $Timer

var segundos:int
var minutos:int

func _ready():
	timer.connect("timeout", self, "tiempo_finalizado")

func _process(delta):
	if Configuracion.comenzar:
		if timer.is_stopped():
			timer.start()
			label.visible = true
	
	minutos = floor(timer.time_left) / 60
	segundos = fmod(timer.time_left, 60)
	label.text = ("%2d" % minutos) + ":" + ("%02d" % segundos)

func tiempo_finalizado() -> void:
	Configuracion.comenzar = false
	timer.stop()
	label.visible = false
	get_tree().change_scene("res://escenas/niveles/nivel_1.tscn")
