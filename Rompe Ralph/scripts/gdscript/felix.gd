extends RigidBody2D


export var velocidad_horizontal: float
export var potencia_salto: float

var playback: AnimationNodeStateMachinePlayback
var direccion: int

func _ready() -> void:
	playback = $AnimationTree.get("parameters/playback")


func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	state.linear_velocity.x = direccion * velocidad_horizontal


func _process(delta: float) -> void:
	if linear_velocity.x != 0:
		playback.travel("correr")
	else:
		playback.travel("idle")
	
	if Input.is_action_pressed("mover_derecha"):
		direccion = 1
	elif Input.is_action_pressed("mover_izquierda"):
		direccion = -1
	else:
		direccion = 0
	
	if direccion == 1:
		$Sprite.flip_h = false
	elif direccion == -1:
		$Sprite.flip_h = true
	
	
	if Input.is_action_just_pressed("saltar") and $RayCast2D.is_colliding():
		apply_central_impulse(Vector2(0, -potencia_salto))
	
	if Input.is_action_just_pressed("reparar"):
		playback	.travel("arreglar")
		for area in $Area2D.get_overlapping_areas():
			if area is Ventana:
				area.reparar()
