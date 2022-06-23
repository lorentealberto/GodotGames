extends Area2D

func _ready():
	$Timer.start()

func _on_Timer_timeout():
	$AnimatedSprite.play("explosion")
	for body in get_overlapping_bodies():
		match body.name:
			"Muro":
				body.queue_free()
			"Jugador":
				Global.vidas -= 1
				get_parent().get_node("Jugador").emit_signal("vida_perdida")

func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"explosion":
			queue_free()
