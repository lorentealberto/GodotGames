extends Node


func _process(delta):
	if get_child_count() == 0:
		print("HAS GANADO")
	else:
		print("Checkpoints restantes: ", get_child_count())
