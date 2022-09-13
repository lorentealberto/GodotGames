extends ActionLeaf

var puntos_referencia: Array
var punto_referencia: Vector3
var contador_punto_referencia: int

func _ready():
	puntos_referencia = get_node("/root/Juego/Brutus/Camino").get_children()
	contador_punto_referencia = 0
	punto_referencia = puntos_referencia[contador_punto_referencia].transform.origin

func tick(actor, blackboard):
	if actor.transform.origin.distance_to(punto_referencia) < 0.2:
		actor.transform.origin = Vector3(punto_referencia.x, actor.transform.origin.y, punto_referencia.z)
		contador_punto_referencia = (contador_punto_referencia + 1) % puntos_referencia.size()
		punto_referencia = puntos_referencia[contador_punto_referencia].transform.origin
	else:
		actor.mover_a(punto_referencia)
	return RUNNING
