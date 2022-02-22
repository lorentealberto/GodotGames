extends KinematicBody2D

onready var animated_sprite = $AnimatedSprite
onready var collision = $CollisionShape2D

onready var run_body = preload("res://bodies/dino_running_body.tres")
onready var crouch_body = preload("res://bodies/dino_crouch_body.tres")

const GRAVITY = 1500
const JUMP_POWER = 7500
var velocity = Vector2.ZERO
var gravity_increment = 0
var jump_time = 0

func _process(_delta):
	if Input.is_action_pressed("crouch"):
		animated_sprite.play("crouch")
		collision.shape = crouch_body
		if not is_on_floor():
			gravity_increment = 7500
	else:
		animated_sprite.play("run")
		collision.shape = run_body
		gravity_increment = 0
		
func _physics_process(delta):
	velocity.x = 0
	velocity.y += (GRAVITY + gravity_increment) * delta
	
	if Input.is_action_pressed("jump") and jump_time < 0.04:
		velocity.y -= JUMP_POWER * delta
		jump_time += delta
	
	if is_on_floor():
		jump_time = 0
	
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
	
