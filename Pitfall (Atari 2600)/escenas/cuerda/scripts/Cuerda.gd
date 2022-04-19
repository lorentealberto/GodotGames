extends Area2D

export(int) var angulos_rotacion = 75
export(float) var velocidad_rotacion = 1

var direccion:String = "izquierda"

func _process(_delta):
	match direccion:
		"izquierda":
			rotation_degrees += velocidad_rotacion
		"derecha":
			rotation_degrees -= velocidad_rotacion

	if int(rotation_degrees) >= angulos_rotacion:
		direccion = "derecha"
	if int(rotation_degrees) <= -angulos_rotacion:
		direccion = "izquierda"

func obtener_posicion_eslabon(id_eslabon:int) -> Vector2:
	return get_child(id_eslabon).global_position
