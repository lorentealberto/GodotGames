extends Node

onready var plPipe = preload("res://scenes/objects/Pipe.tscn")

func _ready():
	randomize()

func _on_Timer_timeout():
	var pipe_instance = plPipe.instance()
	pipe_instance.position = Vector2(155, (randi() % 3) * 25)
	add_child(pipe_instance)
	
