extends Area2D
class_name Agua

func _on_Agua_body_entered(body: Node) -> void:
	if body is Jugador or body is Enemigo:
		$AnimatedSprite.visible = true
		$AnimatedSprite.frame = 0
		$AnimatedSprite.play()
		$AnimatedSprite.position.x = body.position.x
		body.queue_free()


func _on_AnimatedSprite_animation_finished() -> void:
	$AnimatedSprite.visible = false
