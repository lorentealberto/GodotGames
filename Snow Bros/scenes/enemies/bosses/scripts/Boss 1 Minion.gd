extends "res://scenes/enemies/Fly.gd"

var first_land:bool = false
var first_jump:bool = false

func _ready():
	randomize()

func _physics_process(delta):
	if not first_land:
		if not first_jump:
			velocity.y -= rand_range(10000.0, 12500.0) * delta
			first_jump = true

		if is_on_floor():
			if stopped_timer.is_stopped():
				stopped_timer.start()
			velocity.x = 0
		else:
			velocity.x -= rand_range(175.0, 200.0) * delta

		velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	else:
		if not current_state in [States.COVERED, States.ROLLING]:
			choose_action(delta)

func choose_action(delta:float) -> void:
	if first_land:
		.choose_action(delta)

func _on_StoppedTimer_timeout():
	first_land = true
