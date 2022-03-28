extends KinematicBody2D
class_name Enemy

enum States { COVERED, DEAD, DEFEATED, DOWN, IDLE, JUMP, ROLLING, SHAKING_SNOW, WALK }
var current_state = States.IDLE

onready var animated_sprite:AnimatedSprite = $AnimatedSprite

var velocity:Vector2

func _process(delta):
	manage_animations()
	
func _physics_process(_delta):
	apply_gravity(_delta)
	manage_states()
	velocity = move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)

func manage_states() -> void:
	if current_state != States.COVERED and current_state != States.ROLLING:
		if is_on_floor():
			current_state = States.IDLE

func manage_animations() -> void:
	match current_state:
		States.IDLE:
			animated_sprite.play("idle")
		States.COVERED:
			animated_sprite.animation = "covered"

func apply_gravity(delta:float) -> void:
	velocity.y += Settings.WORLD_GRAVITY * delta

func push(vel:float) -> void:
	velocity.x = vel

func drop() -> void:
	velocity.x = 0

func cover() -> void:
	if current_state != States.COVERED and current_state != States.ROLLING:
		current_state = States.COVERED
		animated_sprite.stop()
		animated_sprite.frame = 0
	else:
		animated_sprite.frame += 1
		if animated_sprite.frame >= animated_sprite.frames.get_frame_count("covered") - 1:
			current_state = States.ROLLING


func is_rolling() -> bool:
	return current_state == States.ROLLING

func _on_AnimatedSprite_animation_finished():
	pass
