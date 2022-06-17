extends Area2D

func _on_AnimatedSprite_animation_finished():
	$Sprite.visible = true
func _on_Timer_timeout():
	$Sprite.visible = false
