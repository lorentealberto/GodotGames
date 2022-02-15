extends KinematicBody2D

const UP = Vector2(0, -1)
const BOOST = 12000
const GRAVITY = 500

var motion = Vector2()

func _physics_process(delta):
	motion.x = 0
	motion.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("ui_accept"):
		motion.y = -BOOST * delta
	
	motion = move_and_slide(motion, UP)
