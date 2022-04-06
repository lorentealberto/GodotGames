extends "res://scenes/enemies/Base Enemy.gd"

onready var head_sensor:RayCast2D = $Head
onready var right_sensor:RayCast2D = $Right
onready var left_sensor:RayCast2D = $Left
onready var right_foot:RayCast2D = $RightFoot
onready var left_foot:RayCast2D = $LeftFoot

onready var stopped_timer:Timer = $StoppedTimer

const MAX_DISTANCE:float = 256.0
const MIN_DISTANCE:float = 50.0

var old_pos:float = -1
var block_action:bool = false
var action:int
var platform_mode:bool

var distance:float

func _ready():
	randomize()
	
func _physics_process(delta):
	if not current_state in [States.COVERED, States.ROLLING]:
		choose_action(delta)
		manage_stopped_timer(delta)
	else:
		if left_sensor.is_colliding():
			direction = "right"
		elif right_sensor.is_colliding():
			direction = "left"

func choose_action(delta:float) -> void:
	if not block_action:
		action = randi() % 4
		if rand_range(0.0, 1.0) <= 0.5:
			platform_mode = true
		else:
			platform_mode = false
	match action:
		0, 1: #Jump
			if head_sensor.is_colliding():
				block_action = true
				jump(delta)
		2: #Right
			if not right_sensor.is_colliding():
				if not block_action:
					distance = rand_range(MIN_DISTANCE, MAX_DISTANCE)
					block_action = true

				if platform_mode:
					if right_foot.is_colliding():
						move_distance(distance, "right", delta)
					else:
						stop()
				else:
					move_distance(distance, "right", delta)
		3: #Left
			if not left_sensor.is_colliding():
				if not block_action:
					distance = rand_range(MIN_DISTANCE, MAX_DISTANCE)
					block_action = true
				
				if platform_mode:
					if left_foot.is_colliding():
						move_distance(distance, "left", delta)
					else:
						stop()
				else:
					move_distance(distance, "left", delta)
	#Unlock action
	if action in [0, 1] and is_on_floor():
		block_action = false

func move_distance(distance:float, direction:String, delta:float) -> void:
	if old_pos == -1:
		old_pos = position.x
	if floor(abs(old_pos - position.x)) <= distance:
		go_to(direction, delta)
	else:
		stop()
	check_bounds(direction)

func check_bounds(direction:String) -> void:
	match direction:
		"right":
			if right_sensor.is_colliding() or position.x >= get_viewport_rect().size.x:
				stop()
		"left":
			if left_sensor.is_colliding() or position.x <= 0:
				stop()

func manage_stopped_timer(delta:float) -> void:
	if action in [2, 3]:
		if velocity.x == 0:
			stopped_timer.start()
			jump(delta)
			velocity.x += rand_range(-HSPEED, HSPEED) * delta

func stop() -> void:
	velocity.x = 0
	action = -1
	block_action = false

func _on_StoppedTimer_timeout():
	block_action = false
