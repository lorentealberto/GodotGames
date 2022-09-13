extends ActionLeaf

var llave: String = "posicion_jugador"

func tick(actor, blackboard):
	var posicion_jugador: Vector3 = blackboard.get(llave)
	
	if not posicion_jugador:
		return SUCCESS
	
	actor.mover_a(posicion_jugador)
	
	if actor.transform.origin.distance_to(posicion_jugador) < 1:
		return SUCCESS
	return RUNNING
