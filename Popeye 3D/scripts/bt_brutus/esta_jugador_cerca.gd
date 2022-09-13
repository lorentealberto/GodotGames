extends ConditionLeaf

var llave: String = "posicion_jugador"
var radio_deteccion: int = 10

func tick(actor, blackboard):
	var posicion_jugador: Vector3 = blackboard.get(llave)
	
	if actor.transform.origin.distance_to(posicion_jugador) < radio_deteccion:
		return SUCCESS

	return FAILURE
