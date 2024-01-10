extends Area2D
class_name Bubble

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

const DESIRED_H_SPEED: int = 150
const VSPEED: int = 100
const ACELERATION: float = 20.0

var velocity: Vector2 = Vector2.ZERO
var direction: int = 0
var current_state: int = 0
var bounce: bool = false

func _physics_process(delta: float) -> void:
	match current_state:
		0: #Acelerate
			velocity.x = lerpf(velocity.x, DESIRED_H_SPEED * direction, 1 - exp(-ACELERATION * delta))
			if abs(round(velocity.x)) >= DESIRED_H_SPEED:
				current_state = 1
		1: #Slow down
			velocity.x = lerpf(velocity.x, 0.0, 1 - exp(-ACELERATION * delta))
			if abs(round(velocity.x)) <= 0:
				current_state = 2
		2: #Go up
			if not bounce:
				velocity.y = lerpf(velocity.y, -VSPEED, 1 - exp(-ACELERATION * delta))
			else:
				velocity.y = lerpf(velocity.y, VSPEED, 1 - exp(-ACELERATION * delta))
				if round(velocity.y) >= VSPEED:
					bounce = false
	
	position += velocity * delta

func set_direction(facing_left: bool) -> void:
	if facing_left:
		direction = -1
	else:
		direction = 1

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Roof":
		bounce = true
		if timer.is_stopped():
			timer.start()


func _on_body_entered(body: Node2D) -> void:
	if velocity.x != 0:
		velocity.x = 0
		current_state = 2


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.animation == "explosion":
		call_deferred("queue_free")


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("explosion")
