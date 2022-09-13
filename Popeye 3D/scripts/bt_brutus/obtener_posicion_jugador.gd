extends ActionLeaf

var llave: String = "posicion_jugador"

func tick(actor, blackboard):
	blackboard.set(llave, get_node("/root/Juego/Popeye").global_transform.origin)
	return SUCCESS
