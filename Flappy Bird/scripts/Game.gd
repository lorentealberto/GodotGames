extends Node

func _on_DeadArea_body_entered(body):
	if body.name == "Player":
		get_tree().reload_current_scene()
