extends KinematicBody2D

onready var animated_sprite:AnimatedSprite = $AnimatedSprite

enum Estados { PARADO, CORRIENDO, SALTANDO, ESCALANDO, EN_CUERDA }
var estado_actual:int

const VELOCIDAD_HORIZONTAL:float = 2750.0
const GRAVEDAD:float = 750.0
const POTENCIA_DE_SALTO:float = -10050.0
var velocidad:Vector2
var escalera:Area2D = null
var en_fondo_escalera:bool = false

func _process(_delta):
	gestionar_animaciones()
	actualizar_direccion()
	gestionar_escalera()

func _physics_process(delta):
	aplicar_gravedad(delta)
	gestionar_estados()
	controles(delta)
	velocidad = move_and_slide_with_snap(velocidad, Vector2.DOWN, Vector2.UP)

func aplicar_gravedad(delta:float) -> void:
	if not is_on_floor() and estado_actual != Estados.ESCALANDO:
		velocidad.y += GRAVEDAD * delta

func controles(delta:float) -> void:
	#Movimiento horizontal
	velocidad.x = 0
	if estado_actual != Estados.ESCALANDO:
		if Input.is_action_pressed("ir_derecha"):
			velocidad.x += VELOCIDAD_HORIZONTAL * delta
		elif Input.is_action_pressed("ir_izquierda"):
			velocidad.x -= VELOCIDAD_HORIZONTAL * delta
	#Saltar
	if estado_actual == Estados.ESCALANDO:
		velocidad.y = 0
		if Input.is_action_pressed("saltar"):
			velocidad.y += POTENCIA_DE_SALTO / 3 * delta
	elif Input.is_action_just_pressed("saltar") and is_on_floor():
		velocidad.y += POTENCIA_DE_SALTO * delta

func gestionar_estados() -> void:
	if not estado_actual == Estados.ESCALANDO:
		if is_on_floor():
			estado_actual = Estados.PARADO
		if velocidad.x != 0:
			estado_actual = Estados.CORRIENDO
		if not is_on_floor():
			estado_actual = Estados.SALTANDO

func gestionar_animaciones() -> void:
	match estado_actual:
		Estados.PARADO:
			animated_sprite.play("parado")
		Estados.CORRIENDO:
			animated_sprite.play("corriendo")
		Estados.SALTANDO:
			animated_sprite.play("saltando")
		Estados.ESCALANDO:
			animated_sprite.play("escalando")
			if velocidad.y == 0:
				animated_sprite.stop()
		Estados.EN_CUERDA:
			pass

func actualizar_direccion() -> void:
	if velocidad.x < 0:
		animated_sprite.flip_h = true
	elif velocidad.x > 0:
		animated_sprite.flip_h = false

func gestionar_escalera() -> void:
	if escalera != null and en_fondo_escalera:
		if Input.is_action_pressed("saltar"):
			estado_actual = Estados.ESCALANDO

func _on_Cuerpo_area_entered(area):
	if area.name == "Escalera":
		escalera = area
	if area.name == "Gatillo":
		en_fondo_escalera = true

func _on_Cuerpo_area_exited(area):
	if area.name == "Escalera":
		escalera = null
		en_fondo_escalera = false
		estado_actual = -1
