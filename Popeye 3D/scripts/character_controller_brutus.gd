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
	if linear_velocity.round() == Vector3.ZERO:
		current_state = States.IDLE
	elif round(linear_velocity.y) != 0:
		current_state = States.JUMP
	else:
		current_state = States.WALK
	
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
	state.linear_velocity = Vector3(velocity.x, state.linear_velocity.y, velocity.z)
	velocity = Vector3.ZERO


func mover_a(posicion: Vector3) -> void:
	$Pivot.look_at($Pivot.translation + posicion, Vector3.UP)
	$Pivot.rotation.x = 0
	velocity = $Pivot.global_transform.basis.xform(Vector3.FORWARD) * speed
		
