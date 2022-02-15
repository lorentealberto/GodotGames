extends StaticBody2D


func _physics_process(delta):
	position.x -= 100 * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
