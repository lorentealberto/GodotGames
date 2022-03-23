extends Area2D
class_name Obstacle

func _process(delta):
	position.x -= Settings.FLOOR_VELOCITY * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
