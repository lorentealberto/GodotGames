extends RigidBody2D

# AJUSTES
const VHORIZONTAL: float = 75.0


# VARIABLES DEL SISTEMA
var direccion: int = 0

var enemigo: RigidBody2D = null

func _ready() -> void:
	$AnimationPlayer.play("inicio")
	gravity_scale = 0

func _process(delta: float) -> void:
	if enemigo != null:
		enemigo.position = position


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
	if enemigo != null:
		enemigo.queue_free()
		enemigo = null


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemigos"):
		enemigo = body
