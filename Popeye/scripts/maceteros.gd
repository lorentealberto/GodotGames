extends Node2D

onready var maceteros: Array = [$Macetero_1, $Macetero_2]

func _ready() -> void:
	randomize()
	
func _on_Timer_timeout() -> void:
	for macetero in maceteros:
		macetero.activado = false
	maceteros[randi() % 2].activado = true
