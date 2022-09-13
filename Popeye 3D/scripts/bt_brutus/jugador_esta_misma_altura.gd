extends ConditionLeaf

var llave: String = "posicion_jugador"

func tick(actor, blackboard):
	var posicion_y_jugador: float = blackboard.get(llave).y
	
	if sqrt(pow(actor.transform.origin.y - posicion_y_jugador, 2)) < 1:
		return SUCCESS
	return FAILURE
