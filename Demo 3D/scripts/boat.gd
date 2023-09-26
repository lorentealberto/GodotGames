extends CharacterBody3D

@onready var pivot = $Pivot

const ROTATION_SPEED = .01
const ACCELERATION = .5

var current_speed = 50

	
func _physics_process(delta):
#	CONTROLS
	if Input.is_action_pressed("accelerate") and current_speed <= 75:
		current_speed += ACCELERATION
	elif Input.is_action_pressed("brake") and current_speed >= 10:
		current_speed -= ACCELERATION

	rotate_y(-ROTATION_SPEED * (Input.get_action_strength("turn_right") - Input.get_action_strength("turn_left")))
	
	velocity = global_transform.basis.z * current_speed
	move_and_slide()


func _on_hit_box_area_entered(area):
	if area.get_parent().is_in_group("checkpoints"):
		area.get_parent().call_deferred("queue_free")
