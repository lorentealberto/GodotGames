extends Node2D

export var helicoptero: PackedScene
export var caza: PackedScene
export var barco: PackedScene

func _ready() -> void:
	randomize()
	var instancia_enemigo: Area2D
	match randi() % 3:
		0:
			instancia_enemigo = helicoptero.instance()
		1:
			instancia_enemigo = caza.instance()
		2:
			instancia_enemigo = barco.instance()
	add_child(instancia_enemigo)
	instancia_enemigo.position.x = floor(rand_range($"../Fondo/Position2D".position.x, $"../Fondo/Position2D2".position.x))
