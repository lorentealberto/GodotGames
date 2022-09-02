extends RigidBody

const JUMP_POWER: int = 4
enum States {IDLE, WALK, CLIMB, JUMP}
var current_state: int


var speed: float

var velocity: Vector3

func _ready() -> void:
	speed = 3.0
	velocity = Vector3.ZERO
	
	$Pivot/Character/AnimationPlayer.play("Static")

func _process(delta: float) -> void:
	var direction: Vector3 = Vector3.ZERO
	
	gravity_scale = 1
	
	if Input.is_action_pressed("brutus_mover_derecha"):
		direction.x += 1
	if Input.is_action_pressed("brutus_mover_izquierda"):
		direction.x -= 1
	if Input.is_action_pressed("brutus_mover_atras"):
		if current_state == States.CLIMB:
			direction.y = 1
		else:
			direction.z -= 1
	if Input.is_action_pressed("brutus_mover_adelante"):
		if current_state == States.CLIMB and not $RayCast.is_colliding():
			direction.y = -1
		else:
			direction.z += 1
	
	if Input.is_action_just_pressed("brutus_saltar") and $RayCast.is_colliding():
		apply_central_impulse(Vector3.UP * JUMP_POWER)
	
	if direction != Vector3.ZERO and direction.y == 0:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
	
	velocity.x = direction.x * speed
	
	velocity.z = direction.z * speed
	
	velocity.y = direction.y * speed
	
	
	if linear_velocity.round() == Vector3.ZERO:
		current_state = States.IDLE
	elif round(linear_velocity.y) != 0:
		current_state = States.JUMP
	else:
		current_state = States.WALK
	
	for area in $CuerpoBrutus.get_overlapping_areas():
		if area.name == "EscaleraVertical":
			current_state = States.CLIMB
	
	match current_state:
		States.IDLE:
			$Pivot/Character/AnimationPlayer.play("Static")
		States.WALK:
			$Pivot/Character/AnimationPlayer.play("Walk")
		States.CLIMB:
			$Pivot/Character/AnimationPlayer.play("Climb")
			gravity_scale = 0
			$Pivot.rotation_degrees.y = 0
		States.JUMP:
			$Pivot/Character/AnimationPlayer.play("Jump")
	
func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	if current_state != States.CLIMB:
		velocity.y = state.linear_velocity.y
	state.linear_velocity = Vector3(velocity.x, velocity.y, velocity.z)
	
