extends Node

const TRANS:int = Tween.TRANS_SINE
const EASE:int = Tween.EASE_IN_OUT

var amplitud:float = 0

onready var camara:Camera2D = get_parent()

func _ready():
	pass

func nuevo_temblor() -> void:
	var rnd:Vector2 = Vector2()
	rnd.x = rand_range(-amplitud, amplitud)
	rnd.y = rand_range(-amplitud, amplitud)
	$InterpolacionTemblor.interpolate_property(camara, "offset", camara.offset, rnd, $Frecuencia.wait_time, TRANS, EASE)
	$InterpolacionTemblor.start()


func _on_Frecuencia_timeout():
	nuevo_temblor()
