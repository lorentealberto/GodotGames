extends Area2D

const SPEED = -500

func _physics_process(delta):
	position.y += SPEED * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
