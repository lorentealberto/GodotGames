extends Node2D

var direction = Vector2(5, 0)
var gap = -7
var next_tail_dir = Vector2(1, 0)
var prev_dir = Vector2(1, 0)

onready var tail = preload("res://scenes/states/minigames/Snake/Tail.tscn")

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2(0, -5)
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2(0, 5)
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2(-5, 0)
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2(5, 0)
		
	move_snake()

func move_snake():
	var head_position = $Head.position
	$Head.position += direction / 2
	
	var dir_change = false
	if prev_dir != direction:
		prev_dir = direction
		dir_change = true
	if dir_change:
		for i in range(1, get_child_count()):
			get_child(i).add_to_tail(head_position, direction)
			
func add_tail():
	var instance = tail.instance()
	var prev_tail = get_child(get_child_count() - 1)
	if prev_tail.name != "Head":
		instance.cur_dir = prev_tail.cur_dir
		for i in range(prev_tail.pos_array.size()):
			instance.pos_array.append(prev_tail.pos_array[i])
			instance.directions.append(prev_tail.directions[i])
		instance.position = prev_tail.position + prev_tail.cur_dir * gap
	else:
		instance.cur_dir = direction
		instance.position = prev_tail.position + direction * gap
	call_deferred("add_child", instance)
