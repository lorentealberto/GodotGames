extends RigidBody

func _ready() -> void:
	randomize()
	apply_central_impulse(Vector3(rand_range(-3.0, 3.0), 0, rand_range(0.2, 2.0)))


func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()
