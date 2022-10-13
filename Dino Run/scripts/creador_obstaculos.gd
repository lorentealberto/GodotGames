extends Node

onready var pl_obstaculo: PackedScene = preload("res://objetos/obstaculo.tscn")
onready var pl_obstaculo_dinamico: PackedScene = preload("res://objetos/obstaculo_dinamico.tscn")

func _ready() -> void:
	randomize()

func _on_Timer_timeout() -> void:
	var obstaculo: Area2D
	
	if randi() % 2 == 0:
		obstaculo = pl_obstaculo.instance()
		obstaculo.position = $Suelo.global_position
	else:
		obstaculo = pl_obstaculo_dinamico.instance()
		obstaculo.position = $Aire.global_position
	get_parent().add_child(obstaculo)
	
