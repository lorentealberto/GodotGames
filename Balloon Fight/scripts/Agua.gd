extends Area2D

func _on_Agua_body_entered(body: Node) -> void:
	if body.name == "Jugador" or body.is_in_group("enemigos"):
		$AnimatedSprite.visible = true
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play()
		$AnimatedSprite.position.x = body.position.x
		body.queue_free()


func _on_AnimatedSprite_animation_finished() -> void:
	$AnimatedSprite.visible = false
