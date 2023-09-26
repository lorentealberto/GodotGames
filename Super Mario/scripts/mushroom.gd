extends CharacterBody2D

const GRAVITY = 50
const HSPEED = 50

var dir = 1

func _physics_process(delta):
	_apply_gravity()
	_move()
	
	move_and_slide()


func _move():
	if dir == 1:
		velocity.x = HSPEED
	elif dir == -1:
		velocity.x = -HSPEED

func _apply_gravity():
	if not is_on_floor():
		velocity.y += GRAVITY


func _on_area_2d_body_entered(body):
	if body.is_in_group("pipes"):
		dir *= -1
