extends KinematicBody2D

signal caida

onready var animated_sprite:AnimatedSprite = $AnimatedSprite
onready var pl_polvo:PackedScene = preload("res://escenas/jugador/Polvo.tscn")

enum Estados { PARADO, CORRIENDO, SALTANDO, ESCALANDO, EN_CUERDA }
var estado_actual:int

const VELOCIDAD_HORIZONTAL:float = 2750.0
const GRAVEDAD:float = 750.0
const POTENCIA_DE_SALTO:float = -10050.0
var velocidad:Vector2
var escalera:Area2D = null
var en_fondo_escalera:bool = false
var velocidad_anterior:Vector2 = Vector2.ZERO

func _process(_delta):
	gestionar_animaciones()
	actualizar_direccion()
	gestionar_escalera()

func _physics_process(delta):
	aplicar_gravedad(delta)
	gestionar_estados()
	controles(delta)
	velocidad = move_and_slide_with_snap(velocidad, Vector2.DOWN, Vector2.UP)
	impacto_caida()
	velocidad_anterior = velocidad

func impacto_caida() -> void:
	if velocidad.y == 0 and velocidad_anterior.y != 0:
		if (sqrt(pow(velocidad_anterior.y - velocidad.y, 2))) > 160:
			crear_polvo()
			emit_signal("caida")

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

func crear_polvo() -> void:
	
	var posicion_polvo:Vector2 = Vector2(0, 20)
	var instancia_polvo:Position2D = pl_polvo.instance()
	instancia_polvo.position = global_position + posicion_polvo
	add_child(instancia_polvo)
	
	instancia_polvo = pl_polvo.instance()
	instancia_polvo.scale.x = -1
	instancia_polvo.position = global_position + posicion_polvo
	add_child(instancia_polvo)
	
	instancia_polvo = pl_polvo.instance()
	instancia_polvo.position = global_position + posicion_polvo
	instancia_polvo.scale = Vector2(0.5, 0.5)
	add_child(instancia_polvo)
	instancia_polvo = pl_polvo.instance()
	instancia_polvo.position = global_position + posicion_polvo
	instancia_polvo.scale = Vector2(-0.5, 0.5)
	add_child(instancia_polvo)
	

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
