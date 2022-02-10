extends KinematicBody2D

var direction = Vector2()
var speeds = [-500, 500]

func _ready():
	randomize()
	direction = Vector2(speeds[randi() % speeds.size()], 450)

func _physics_process(delta):
	var collision = move_and_collide(direction * delta)
	if collision:
		var reflect = collision.remainder.bounce(collision.normal)
		direction = direction.bounce(collision.normal)
		move_and_collide(reflect)
		if collision.collider.is_in_group("bricks"):
			collision.collider.hit()

func _on_VisibilityNotifier2D_screen_exited():
	get_tree().reload_current_scene()
