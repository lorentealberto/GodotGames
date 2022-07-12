extends RigidBody2D

onready var pl_score:PackedScene = preload("res://assets/prefabs/score.tscn")

enum Estados {IDLE, SALTANDO, CORRIENDO, EN_ESCALERA}
var estado_actual:int


const VELOCIDAD_HORIZONTAL:float = 40.0
const VELOCIDAD_ESCALERA:float = 20.0
const FUERZA_SALTO:float = 50.0

var horizontal:int
var en_suelo:bool
var tocando_escalera:bool
var puntuacion:int

func _ready() -> void:
	estado_actual = Estados.IDLE
	tocando_escalera = false
	puntuacion = 0

func _process(_delta:float) -> void:
	if tocando_escalera:
		if en_suelo:
			if Input.is_action_just_pressed("bajar"):
				estado_actual = Estados.EN_ESCALERA
		else:
			estado_actual = Estados.EN_ESCALERA
	
	if estado_actual != Estados.EN_ESCALERA:
		if linear_velocity == Vector2.ZERO:
			estado_actual = Estados.IDLE
		elif floor(linear_velocity.y) < -5:
			estado_actual = Estados.SALTANDO
		elif horizontal != 0:
			estado_actual = Estados.CORRIENDO

	match estado_actual:
		Estados.IDLE:
			$Animaciones.play("idle")
		Estados.SALTANDO:
			$Animaciones.play("jump")
		Estados.CORRIENDO:
			$Animaciones.play("walk")
		Estados.EN_ESCALERA:
			if linear_velocity.y == 0:
				$Animaciones.stop()
			else:
				$Animaciones.play("stairs")
	
	if en_suelo and estado_actual != Estados.EN_ESCALERA:
		if Input.is_action_pressed("mover_izquierda"):
			horizontal = -1
		elif Input.is_action_pressed("mover_derecha"):
			horizontal = 1
		else:
			horizontal = 0
	
	if horizontal < 0:
		$Animaciones.flip_h = true
	elif horizontal > 0:
		$Animaciones.flip_h = false
	
	if estado_actual == Estados.EN_ESCALERA:
		horizontal = 0
		$Pies.enabled = false
	else:
		$Pies.enabled = true
	
	if $Pies.is_colliding():
		en_suelo = true
	else:
		en_suelo = false

	if estado_actual != Estados.EN_ESCALERA:
		
		if Input.is_action_just_pressed("saltar") and en_suelo and estado_actual != Estados.EN_ESCALERA:
			apply_central_impulse(Vector2.UP * FUERZA_SALTO)

func _integrate_forces(state) -> void:
	if estado_actual == Estados.EN_ESCALERA:
		$CollisionShape2D.set_deferred("disabled", true)
		gravity_scale = 0
		if Input.is_action_pressed("saltar"):
			state.linear_velocity.y = -VELOCIDAD_ESCALERA
		elif Input.is_action_pressed("bajar"):
			state.linear_velocity.y = VELOCIDAD_ESCALERA
		else:
			state.linear_velocity.y = 0
	else:
		gravity_scale = 1
		$CollisionShape2D.set_deferred("disabled", false)
	
	state.set_linear_velocity(Vector2(horizontal * VELOCIDAD_HORIZONTAL, state.linear_velocity.y))

func _on_DetectScore_body_entered(body):
	if body is Barril:
		puntuacion += 100
		var score_instance := pl_score.instance()
		get_parent().add_child(score_instance)
		score_instance.position = $DetectScore.global_position

func _on_Cuerpo_area_entered(area):
	match area.name:
		"Escaleras":
			tocando_escalera = true
		"Peach":
			get_tree().change_scene("res://assets/scenes/has_ganado.tscn")

func _on_Cuerpo_area_exited(area):
	if area.name == "Escaleras":
		tocando_escalera = false
		estado_actual = Estados.IDLE


func _on_Cuerpo_body_entered(body):
	if body is Barril:
		get_tree().change_scene("res://assets/scenes/has_perdido.tscn")
