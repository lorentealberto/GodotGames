extends Node

var corazon_actual: int

func _ready() -> void:
	corazon_actual = 0


func _on_Popeye_corazon_cogido() -> void:
	get_child(corazon_actual).visible = true
	corazon_actual += 1
	if corazon_actual >= get_child_count():
		get_tree().change_scene("res://escenas/intro.tscn")
