extends CollisionShape2D

func _on_Timer_timeout():
	if randi() % 3 < 2:
		disabled = true
	else:
		disabled = false


func _on_Boss_1_defeated():
	disabled = true
