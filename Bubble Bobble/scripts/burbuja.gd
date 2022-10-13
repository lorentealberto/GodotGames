extends RigidBody2D

# AJUSTES
const VHORIZONTAL: float = 75.0


# VARIABLES DEL SISTEMA
var direccion: int = 0

func _ready() -> void:
	$AnimationPlayer.play("inicio")
	gravity_scale = 0

func _process(delta: float) -> void:
	pass


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if gravity_scale == 0:
		state.linear_velocity.x = VHORIZONTAL * direccion
	else:
		state.linear_velocity.x = 0

func _on_Timer_timeout():
	gravity_scale = -1

func establecer_direccion(_direccion: int) -> void:
	direccion = _direccion


func _on_DeadTimer_timeout():
	$AnimationPlayer.play("explosion")
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
