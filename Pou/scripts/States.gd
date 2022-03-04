extends Node

var current_state = 0
var states = ["res://scenes/states/Kitchen.tscn", "res://scenes/states/Bedroom.tscn", "res://scenes/states/Playground.tscn"]

func change_scene():
	if current_state > len(states) - 1:
		current_state = 0
	elif current_state < 0:
		current_state = len(states) - 1
		
	get_tree().change_scene(states[current_state])

func go_to(scene_path):
	get_tree().change_scene(scene_path)
