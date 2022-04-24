extends Node

onready var label:Label = $CanvasLayer/Control/Label
onready var timer:Timer = $Timer

var segundos:int
var minutos:int

func _process(delta):
	if Configuracion.comenzar:
		if timer.is_stopped():
			timer.start()
			label.visible = true

	minutos = floor(timer.time_left) / 60
	segundos = fmod(timer.time_left, 60)
	label.text = ("%02d" % minutos) + ":" + ("%02d" % segundos)


func _on_Timer_timeout():
	get_tree().change_scene("res://Escenas/Sistema/Estados/Niveles/Nivel 1.tscn")
	Configuracion.comenzar = false
	timer.stop()
	label.visible = false
