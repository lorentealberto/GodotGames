extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var ray_cast_2d: RayCast2D = $RayCast2D



const ACCELERATION: float = 10.0
const GRAVITY: float = 9.8
const JFORCE: float = -235.0
const MAX_H_SPEED: float = 40.0
const MAX_V_SPEED: float = 75.0

var direction: int
var can_auto_jump: bool

func _ready() -> void:
	randomize()
	_generate_random_direction()
	_flip_sprite()
	

func _physics_process(delta: float) -> void:
	_apply_gravity()
	
	if can_auto_jump:
		if not ray_cast_2d.is_colliding() and is_on_floor():
			_jump()
			
	_horizontal_movement()
	
	move_and_slide()

func _apply_gravity() -> void:
	if not is_on_floor():
		velocity.y += GRAVITY
	_check_terminal_velocity()

func _check_terminal_velocity() -> void:
	if velocity.y > MAX_V_SPEED:
		velocity.y = MAX_V_SPEED


func _horizontal_movement() -> void:
	if is_on_floor():
		if is_on_wall():
			direction *= -1

		velocity.x = lerpf(velocity.x, direction * MAX_H_SPEED, 1 - exp(-ACCELERATION * get_physics_process_delta_time()))
	else:
		velocity.x = 0
	
	
	_flip_sprite()

func _flip_sprite() -> void:
	if direction < 0: #If going left
		animated_sprite_2d.flip_h = false
	elif direction > 0: #If going right
		animated_sprite_2d.flip_h = true

	
func _jump() -> void:
	velocity.y = JFORCE

func _generate_random_direction() -> void:
	direction = randi() % 2
	if direction == 0:
		direction = -1
