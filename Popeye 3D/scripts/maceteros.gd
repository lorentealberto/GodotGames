extends Node

onready var maceteros: Array = [$Macetero1, $Macetero2]

func _ready() -> void:
	randomize()
	
	

func _on_Timer_timeout() -> void:
	for macetero in maceteros:
		macetero.activado = false
	maceteros[randi() % 2].activado = true
