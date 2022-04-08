extends "res://scenes/enemies/Base Enemy.gd"

onready var pl_flame = preload("res://scenes/enemies/Flame.tscn")

var current_direction:String = "right"

func _physics_process(delta):
	if not is_rolling() and not is_covered():
		move_along(delta)
	else:
		if left_sensor.is_colliding():
			direction = "right"
		elif right_sensor.is_colliding():
			direction = "left"

func move_along(delta:float) -> void:
	match current_direction:
		"right":
			if right_foot.is_colliding() and not right_sensor.is_colliding():
				go_to(current_direction, delta)
			else:
				stop()
				if not right_sensor.is_colliding():
					shoot()
				current_direction = "left"
		"left":
			if left_foot.is_colliding() and not left_sensor.is_colliding():
				go_to(current_direction, delta)
			else:
				stop()
				if not left_sensor.is_colliding():
					shoot()
				current_direction = "right"

func shoot() -> void:
	var flame:Flame = pl_flame.instance()
	flame.position = global_position
	flame.direction = current_direction
	get_parent().get_parent().add_child(flame)
