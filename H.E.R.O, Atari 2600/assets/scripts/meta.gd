extends Area2D

func _on_Meta_body_entered(body):
	if body.name == "Jugador":
		get_tree().change_scene("res://assets/scenes/pantalla_final.tscn")
