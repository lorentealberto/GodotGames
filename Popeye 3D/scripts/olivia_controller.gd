extends RigidBody

onready var pl_corazon := preload("res://objetos/corazon.tscn")

const SPEED: float = 2.0
var velocity: Vector3
var direccion: Vector3

func _ready() -> void:
	velocity = Vector3.ZERO
	direccion.x = 1
	
	$Pivot/Character/AnimationPlayer.get_animation("Walk").loop = true
	$Pivot/Character/AnimationPlayer.play("Walk");

func _process(delta: float) -> void:
	if direccion != Vector3.ZERO:
		direccion = direccion.normalized()
		$Pivot.look_at(translation + -direccion, Vector3.UP)
	velocity.x = direccion.x * SPEED

func _integrate_forces(state: PhysicsDirectBodyState) -> void:
	state.linear_velocity = Vector3(velocity.x, state.linear_velocity.y, state.linear_velocity.z)
	
func _on_Timer_timeout() -> void:
	var instancia_corazon = pl_corazon.instance()
	instancia_corazon.transform.origin = $SpawnPosition.global_transform.origin
	get_parent().add_child(instancia_corazon)


func _on_Cuerpo_area_entered(area: Area) -> void:
	if area.name == "LimitesTejado":
		direccion *= -1
