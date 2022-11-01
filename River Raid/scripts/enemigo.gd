extends Area2D
class_name Enemigo


func destruir() -> void:
	$AnimatedSprite.visible = false
	$Sprite.visible = true
	$Timer.start()


func _on_Timer_timeout():
	queue_free()
