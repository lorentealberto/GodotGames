extends Node2D

export var helicoptero: PackedScene

func _ready() -> void:
	randomize()
	var instancia_enemigo: Area2D = helicoptero.instance()
	add_child(instancia_enemigo)
	instancia_enemigo.position.x = floor(rand_range(0, 160))
