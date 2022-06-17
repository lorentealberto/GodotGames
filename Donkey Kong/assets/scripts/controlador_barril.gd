extends RigidBody2D
class_name Barril

const MAX_MS_DESACTIVADO:float = 0.5
var tiempo_cuerpo_desactivado:float

var estaba_en_suelo:bool
var en_suelo:bool

var velocidad_horizontal:float
var primera_linea:bool

func _ready():
	randomize()
	velocidad_horizontal = 30
	primera_linea = true

func _process(delta):
	if not en_suelo:
		$AnimatedSprite.play("fall")
	else:
		$AnimatedSprite.play("move")
		
	if not $RayCast2D.enabled:
		tiempo_cuerpo_desactivado += delta
		if tiempo_cuerpo_desactivado > MAX_MS_DESACTIVADO:
			tiempo_cuerpo_desactivado = 0
			$CollisionShape2D.set_deferred("disabled", false)
			$RayCast2D.enabled = true
		
func _integrate_forces(state):
	state.linear_velocity.x = velocidad_horizontal
	
	if $RayCast2D.is_colliding():
		en_suelo = true
		if $RayCast2D.get_collider().name == "Escaleras":
			if randi() % 300 < 10:
				$CollisionShape2D.set_deferred("disabled", true)
				$RayCast2D.enabled = false
				state.linear_velocity.x /= 2
	else:
		en_suelo = false
		state.linear_velocity.x /= 2
		
	if not estaba_en_suelo and en_suelo:
		if not primera_linea:
			velocidad_horizontal *= -1
		else:
			primera_linea = false
			
	estaba_en_suelo = en_suelo
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
