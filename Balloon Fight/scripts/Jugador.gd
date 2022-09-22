extends RigidBody2D

var activado: bool = false
var n_globos: String = "dos_globos"
var velocidad: int = 0


func _process(delta: float) -> void:
	if activado: # Se comprueba que el personaje esté activado
		pass
	else: # Si alguno de los controles ha sido pulsado, se activa el personaje
		if (Input.is_action_just_pressed("mover_derecha") or
			Input.is_action_just_pressed("mover_izquierda") or
			Input.is_action_just_pressed("aletear")):
				activado = true
