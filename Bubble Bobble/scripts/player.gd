extends CharacterBody2D
class_name Player
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var bubbles_group: Node
@export var bubble_tscn: PackedScene

#Configuration
const ACCELERATION: float = 10.0
const GRAVITY: float = 9.8
const JFORCE: float = -235.0
const MAX_H_SPEED: float = 100.0
const MAX_V_SPEED: float = 75.0
const MOVEMENT_INFLECTION_POINT: float = 5.0

#Core vars
var _is_shooting: bool = false

func _physics_process(delta: float) -> void:
	_apply_gravity()
	_manage_controls()
	
	move_and_slide()
	
	_manage_animations()

#Apply gravity to player velocity
func _apply_gravity() -> void:
	if not is_on_floor():
		velocity.y += GRAVITY
	
	_check_terminal_velocity()

#Checks player terminal velocity. Terminal velocity is max possible fall speed
func _check_terminal_velocity() -> void:
	if velocity.y > MAX_V_SPEED:
		velocity.y = MAX_V_SPEED

func _manage_controls() -> void:
	#Horizontal controls
	var desired_speed: float = (Input.get_action_strength("move_right") - Input.get_action_strength("move_left")) * MAX_H_SPEED
	velocity.x = lerpf(velocity.x, desired_speed, 1 - exp(-ACCELERATION * get_physics_process_delta_time()))
	_flip_sprite(desired_speed)
	
	#Vertical controls
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JFORCE
	
	#Shoot
	if Input.is_action_just_pressed("shoot") and not _is_shooting:
		_shoot()
		

func _flip_sprite(desired_speed: float) -> void:
	if desired_speed < 0.0: #If going left
		animated_sprite_2d.flip_h = true
	elif desired_speed > 0.0: #If going right
		animated_sprite_2d.flip_h = false

#States machine
func _manage_animations() -> void:
	if _is_shooting: #Player is shooting
		animated_sprite_2d.play("shoot")
	else: #Player is not shooting
		if is_on_floor(): #Player is on floor
			if abs(round(velocity.x)) < MOVEMENT_INFLECTION_POINT: #Player velocity is near 0
				animated_sprite_2d.play("idle")
			else: #Player velocity is not near 0
				animated_sprite_2d.play("walk")
		else: #Player is not on floor
			if velocity.y > 0: #Player is falling
				animated_sprite_2d.play("fall")
			else: #Player is jumping
				animated_sprite_2d.play("jump")

func _shoot() -> void:
	_is_shooting = true
	var bubble_inst: Bubble = bubble_tscn.instantiate()
	bubble_inst.set_direction(animated_sprite_2d.flip_h)
	bubble_inst.global_position = position
	bubbles_group.add_child(bubble_inst)
	
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "shoot":
		_is_shooting = false
