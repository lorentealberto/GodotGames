extends RigidBody2D

const VELOCIDAD_HORIZONTAL: float = 40.0
const VELOCIDAD_ESCALERA: float = 35.0

var horizontal: int

enum Estados {INACTIVO, ANDANDO}
var estado_actual: int

signal corazon_cogido

func _ready() -> void:
	horizontal = 0
	estado_actual = Estados.INACTIVO

func _process(delta: float) -> void:
	#Máquina de estados
	if horizontal == 0:
		estado_actual = Estados.INACTIVO
	else:
		estado_actual = Estados.ANDANDO
	
	match estado_actual:
		Estados.INACTIVO:
			$AnimatedSprite.play("inactivo")
		Estados.ANDANDO:
			$AnimatedSprite.play("andar")
	
	#Controles
	#Movimiento horizontal
	if Input.is_action_pressed("popeye_derecha"):
		horizontal = 1
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("popeye_izquierda"):
		horizontal = -1
		$AnimatedSprite.flip_h = true
	else:
		horizontal = 0

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#Reiniciar físicas
	$CollisionShape2D.set_deferred("disabled", false)
	gravity_scale = 1
	
	state.set_linear_velocity(Vector2(horizontal * VELOCIDAD_HORIZONTAL, state.linear_velocity.y))

	#Subir / Bajar escalera vertical
	for area in $CuerpoPopeye.get_overlapping_areas():
		
		match area.name:
			"EscaleraVertical":
				desactivar_fisicas()
				if Input.is_action_pressed("popeye_bajar"):
					state.linear_velocity.y = VELOCIDAD_ESCALERA
				elif Input.is_action_pressed("popeye_subir"):
					state.linear_velocity.y = -VELOCIDAD_ESCALERA
				else:
					state.linear_velocity.y = 0
	
	#Bajar escaleras horizontales
	for body in $CuerpoPopeye.get_overlapping_bodies():
		match body.name:
			"EscalerasDerechas":
				desactivar_fisicas()
				if Input.is_action_pressed("popeye_bajar"):
					state.linear_velocity.y = VELOCIDAD_ESCALERA
					state.linear_velocity.x = 25
				elif Input.is_action_pressed("popeye_subir"):
					state.linear_velocity.y = -VELOCIDAD_ESCALERA
					state.linear_velocity.x = -25
				else:
					state.linear_velocity.y = 0
			"EscalerasIzquierdas":
				desactivar_fisicas()
				if Input.is_action_pressed("popeye_bajar"):
					state.linear_velocity.y = VELOCIDAD_ESCALERA
					state.linear_velocity.x = -25
				elif Input.is_action_pressed("popeye_subir"):
					state.linear_velocity.y = -VELOCIDAD_ESCALERA
					state.linear_velocity.x = 25
				else:
					state.linear_velocity.y = 0

func desactivar_fisicas() -> void:
	gravity_scale = 0
	$CollisionShape2D.set_deferred("disabled", true)

func _on_Area2D_area_entered(area: Area2D) -> void:
	match area.name:
		"CuerpoCorazon":
			area.get_parent().queue_free()
			emit_signal("corazon_cogido")
		"CuerpoBrutus":
			get_tree().reload_current_scene()
