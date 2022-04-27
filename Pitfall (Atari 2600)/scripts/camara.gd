extends Node

onready var tween:Tween = $Tween
onready var frecuencia:Timer = $Frecuencia
onready var duracion:Timer = $Duracion

const TRANS:int = Tween.TRANS_SINE
const EASE:int = Tween.EASE_IN_OUT

var amplitud:float = 0
var prioridad:int = 0

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func comenzar(duracion:float = 0.2, frecuencia:float = 15.0, amplitud:float = 16, prioridad:int = 0):
	if prioridad >= self.prioridad:
		self.prioridad = prioridad
		self.amplitud = amplitud
		self.duracion.wait_time = duracion
		self.frecuencia.wait_time = 1 / frecuencia
		self.duracion.start()
		self.frecuencia.start()
		nuevo_temblor()

func nuevo_temblor() -> void:
	var rnd:Vector2 = Vector2()
	rnd.x = rand_range(-amplitud, amplitud)
	rnd.y = rand_range(-amplitud, amplitud)
# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "offset", self.offset, rnd, frecuencia.wait_time, TRANS, EASE)
# warning-ignore:return_value_discarded
	tween.start()

func reiniciar() -> void:
# warning-ignore:return_value_discarded
	tween.interpolate_property(self, "offset", self.offset, Vector2(),  frecuencia.wait_time, TRANS, EASE)
# warning-ignore:return_value_discarded
	tween.start()
	prioridad = 0

func _on_Frecuencia_timeout():
	nuevo_temblor()

func _on_Duracion_timeout():
	reiniciar()
	frecuencia.stop()
