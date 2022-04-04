extends "res://scenes/enemies/Base Enemy.gd"

onready var top:RayCast2D = $Top
onready var right:RayCast2D = $Right
onready var left:RayCast2D = $Left
onready var action_timer:Timer = $ActionTimer

var can_go_right:bool = false
var can_go_left:bool = false
var can_go_up:bool = false
var do:int = -1

func _physics_process(delta):
	randomize()
	

	
	match do:
		0:
			if not left.is_colliding():
				go_to("left", delta)
			else:
				return
		1:
			if not right.is_colliding():
				go_to("right", delta)
			else:
				return
		2:
			if not top.is_colliding():
				can_jump = true
			else:
				return
			
	position.x = clamp(position.x, 0, get_viewport_rect().size.x)
	if position.x == 0:
		do = 1
		action_timer.wait_time = rand_range(1, 2)
	elif position.x == get_viewport_rect().size.x:
		do = 0
		action_timer.wait_time = rand_range(1, 2)

func _on_ActionTimer_timeout():
	action_timer.wait_time = rand_range(1, 2)
	do = randi() % 3


func _on_Red_Demon_on_floor():
	can_jump = false
	do = -1
