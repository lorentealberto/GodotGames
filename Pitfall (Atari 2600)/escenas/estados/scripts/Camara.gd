extends Node

const TRANS:int = Tween.TRANS_SINE
const EASE:int = Tween.EASE_IN_OUT

var amplitud:float = 0
var prioridad:int = 0

onready var camara:Camera2D = get_parent()

func comenzar(duracion:float = 0.2, frecuencia:float = 15.0, amplitud:float = 16, prioridad:int = 0):
	if prioridad >= self.prioridad:
		self.prioridad = prioridad
		self.amplitud = amplitud
		
		$Duracion.wait_time = duracion
		$Frecuencia.wait_time = 1 / frecuencia
		$Duracion.start()
		$Frecuencia.start()
		nuevo_temblor()
	
func nuevo_temblor() -> void:
	var rnd:Vector2 = Vector2()
	rnd.x = rand_range(-amplitud, amplitud)
	rnd.y = rand_range(-amplitud, amplitud)
	$InterpolacionTemblor.interpolate_property(camara, "offset", camara.offset, rnd, $Frecuencia.wait_time, TRANS, EASE)
	$InterpolacionTemblor.start()

func reiniciar() -> void:
	$InterpolacionTemblor.interpolate_property(camara, "offset", camara.offset, Vector2(), $Frecuencia.wait_time, TRANS, EASE)
	$InterpolacionTemblor.start()
	
	prioridad = 0

func _on_Frecuencia_timeout():
	nuevo_temblor()


func _on_Duracion_timeout():
	reiniciar()
	$Frecuencia.stop()
