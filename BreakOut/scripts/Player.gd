extends KinematicBody2D

func move_to(pos):
	global_position.x = pos.x

func drag_to(pos):
	global_position = pos
