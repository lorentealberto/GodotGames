extends RigidBody2D

func _ready() -> void:
	randomize()
	apply_central_impulse(Vector2(rand_range(-5.0, 5.0), -50))


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
