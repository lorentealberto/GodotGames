extends Node

onready var label:Label = $CanvasLayer/Control/Label
onready var timer:Timer = $Timer

var segundos:int
var minutos:int

func _process(delta):
	minutos = floor(timer.time_left) / 60
	segundos = fmod(timer.time_left, 60)
	label.text = ("%02d" % minutos) + ":" + ("%02d" % segundos)


func _on_Timer_timeout():
	get_tree().change_scene("res://Escenas/Sistema/Estados/Niveles/Nivel 1.tscn")
