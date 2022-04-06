extends "res://scenes/enemies/Base Enemy.gd"

onready var pl_flame = preload("res://scenes/enemies/Flame.tscn")

var current_direction:String = "right"

func _physics_process(delta):
	if current_direction == "right":
		if right_foot.is_colliding() and not right_sensor.is_colliding():
			go_to(current_direction, delta)
		else:
			if not right_sensor.is_colliding():
				#Shoot
				shoot()
			current_direction = "left"
			velocity.x = 0
			
	elif current_direction == "left":
		if left_foot.is_colliding() and not left_sensor.is_colliding():
			go_to(current_direction, delta)
		else:
			#Shoot
			
			if left_sensor.is_colliding():
				#Shoot
				shoot()
				current_direction = "right"
				velocity.x = 0

func shoot() -> void:
	var flame:Flame = pl_flame.instance()
	flame.position = position
	flame.direction = current_direction

	get_parent().get_parent().add_child(flame)
