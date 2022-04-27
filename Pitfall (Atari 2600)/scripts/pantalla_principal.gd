extends Control

func _ready():
	if Configuracion.comenzar:
		visible = false
