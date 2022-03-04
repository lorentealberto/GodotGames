extends Node2D

onready var pupil = $Pupil

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	pupil.look_at(mouse_pos)
