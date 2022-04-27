extends Control

onready var label:Label = $Label
onready var timer:Timer = $Timer

var segundos:int
var minutos:int

func _ready():
	timer.connect("timeout", self, "tiempo_finalizado")

func _process(delta):
<<<<<<< HEAD:Pitfall (Atari 2600)/Escenas/Sistema/Cuenta Atras/Scripts/Cuenta Atras.gd
=======
	if Configuracion.comenzar:
		if timer.is_stopped():
			timer.start()
			label.visible = true
	
>>>>>>> 31979eb6513709c93c2787eb7b1d2291642fb81d:Pitfall (Atari 2600)/scripts/cuenta_atras.gd
	minutos = floor(timer.time_left) / 60
	segundos = fmod(timer.time_left, 60)
	label.text = ("%2d" % minutos) + ":" + ("%02d" % segundos)

<<<<<<< HEAD:Pitfall (Atari 2600)/Escenas/Sistema/Cuenta Atras/Scripts/Cuenta Atras.gd
func _on_Timer_timeout():
	get_tree().change_scene("res://Escenas/Sistema/Estados/Niveles/Nivel 1.tscn")
=======
func tiempo_finalizado() -> void:
	Configuracion.comenzar = false
	timer.stop()
	label.visible = false
	get_tree().change_scene("res://escenas/niveles/nivel_1.tscn")
>>>>>>> 31979eb6513709c93c2787eb7b1d2291642fb81d:Pitfall (Atari 2600)/scripts/cuenta_atras.gd
