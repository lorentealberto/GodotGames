extends RigidBody2D

onready var pl_bomba := preload("res://assets/prefabs/bomba.tscn")
onready var pl_shuriken := preload("res://assets/prefabs/shuriken.tscn")

signal vida_perdida
signal bomba_puesta

onready var animated_sprite := $AnimatedSprite
onready var raycast := $RayCast2D

enum Estados {IDLE, ANDANDO, SALTANDO, CAYENDO}
var estado_actual:int

const VELOCIDAD_HORIZONTAL:float = 40.0
const POTENCIA_SALTO:float = 55.0

var horizontal:int
var en_suelo:bool

var volando:bool

const UMBRAL_POTENCIA_TIMER:float = 1000.0
var potencia_timer:float

func _ready():
	horizontal = 0
	en_suelo = false
	estado_actual = Estados.IDLE
	volando = false
	potencia_timer = 0

func _process(delta):
	#Actualizar timer potencia
	if potencia_timer > UMBRAL_POTENCIA_TIMER:
		potencia_timer = 0
		if volando:
			Global.potencia -= 2
		else:
			Global.potencia -= 1
	else:
		potencia_timer += delta * 1000
		
	#Máquina de estados
	if linear_velocity == Vector2.ZERO:
		estado_actual = Estados.IDLE
	if floor(linear_velocity.x) != 0:
		estado_actual = Estados.ANDANDO
	if not en_suelo:
		estado_actual = Estados.SALTANDO
	if floor(linear_velocity.y) > 0:
		estado_actual = Estados.CAYENDO

	match estado_actual:
		Estados.IDLE:
			animated_sprite.play("idle")
		Estados.ANDANDO:
			animated_sprite.play("run")
		Estados.SALTANDO:
			animated_sprite.play("jump")
		Estados.CAYENDO:
			animated_sprite.play("fall")

	#Mover derecha / izquierda
	if Input.is_action_pressed("mover_derecha"):
		horizontal = 1
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("mover_izquierda"):
		horizontal = -1
		animated_sprite.flip_h = true
	else:
		horizontal = 0
	
	#Saltar
	if raycast.is_colliding():
		en_suelo = true
	else:
		en_suelo = false
	
	if Input.is_action_just_pressed("saltar") and en_suelo:
		apply_central_impulse(Vector2.UP * POTENCIA_SALTO)

	#Colocar bomba
	if Input.is_action_just_pressed("colocar_bomba") and Global.bombas > 0 and not volando:
		Global.bombas -= 1
		var instancia_bomba := pl_bomba.instance()
		get_parent().add_child(instancia_bomba)
		instancia_bomba.position = global_position
		emit_signal("bomba_puesta")
	
	#Disparar
	if Input.is_action_just_pressed("disparar"):
		var instancia_shuriken := pl_shuriken.instance()
		instancia_shuriken.flip_h($AnimatedSprite.flip_h)
		get_parent().add_child(instancia_shuriken)
		instancia_shuriken.position = global_position
	
	#Volar
	if volando:
		$CPUParticles2D.emitting = true
		gravity_scale = 0
	else:
		$CPUParticles2D.emitting = false
		gravity_scale = 2
		

func _integrate_forces(state):
	if Input.is_action_pressed("volar"):
		volando = true
		state.linear_velocity.y = -POTENCIA_SALTO / 3
	elif volando:
		state.linear_velocity.y = 0
			
	if Input.is_action_just_pressed("aterrizar"):
		volando = false

	state.set_linear_velocity(Vector2(horizontal * VELOCIDAD_HORIZONTAL, state.linear_velocity.y))
