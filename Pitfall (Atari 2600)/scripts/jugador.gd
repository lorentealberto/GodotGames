extends KinematicBody2D

signal caida

onready var animated_sprite:AnimatedSprite = $AnimatedSprite
onready var camara:Camera2D = get_parent().get_node("Camara")
onready var cuerpo:CollisionShape2D = $CuerpoJugador/CollisionShape2D

onready var pl_polvo:PackedScene = preload("res://prefabs/polvo.tscn")

enum Estados { PARADO, CORRIENDO, SALTANDO, ESCALANDO, EN_CUERDA }

const VELOCIDAD_HORIZONTAL:float = 2750.0
const GRAVEDAD:float = 750.0
const POTENCIA_SALTO:float = -10055.0
const COYOTE_TIME:float = 0.125

var saltos:int
var estado_actual:int

var tiempo_en_aire:float

var velocidad:Vector2
var velocidad_anterior:Vector2

var cuerda:Area2D
var tortuga:StaticBody2D

func _ready():
	# warning-ignore:return_value_discarded
	connect("caida", camara, "comenzar", [0.2, 15, 16, 2])

func _process(delta):
	gestionar_animaciones()
	actualizar_direccion()
	gestionar_escalada(delta)
	gestionar_cuerda(delta)
	comprobar_colision_tortuga()

func gestionar_animaciones() -> void:
	match estado_actual:
		Estados.PARADO:
			animated_sprite.play("parado")
		Estados.CORRIENDO:
			animated_sprite.play("corriendo")
		Estados.SALTANDO:
			animated_sprite.play("saltando")
		Estados.ESCALANDO:
			animated_sprite.play("saltando")
		Estados.EN_CUERDA:
			animated_sprite.play("saltando")

func actualizar_direccion() -> void:
	if velocidad.x < 0:
		animated_sprite.flip_h = true
	elif velocidad.x > 0:
		animated_sprite.flip_h = false

func gestionar_escalada(delta:float) -> void:
	if estado_actual == Estados.ESCALANDO:
		if Input.is_action_pressed("saltar"):
			velocidad.y = POTENCIA_SALTO * delta

func gestionar_cuerda(delta:float) -> void:
	if estado_actual == Estados.EN_CUERDA:
		saltos = 0
		position = get_parent().get_node("Cuerda").obtener_posicion_eslabon(10)
		rotation_degrees = get_parent().get_node("Cuerda").rotation_degrees
		if Input.is_action_just_pressed("saltar"):
			cuerpo.set_deferred("disabled", true)
			rotation_degrees = 0
			saltar(delta)

func comprobar_colision_tortuga() -> void:
	if tortuga != null:
		if tortuga.tiene_espinas_fuera():
			get_tree().reload_current_scene()

func _physics_process(delta:float) -> void:
	if Configuracion.comenzar:
		aplicar_gravedad(delta)
		gestionar_estados()
		controles(delta)
		velocidad = move_and_slide_with_snap(velocidad, Vector2.DOWN, Vector2.UP)
		impacto_caida()
		velocidad_anterior = velocidad

func aplicar_gravedad(delta:float) -> void:
	if not is_on_floor() and not estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
		velocidad.y += GRAVEDAD * delta
	elif is_on_floor():
		saltos = 0
		if cuerpo.is_disabled():
			cuerpo.set_deferred("disabled", false)

func gestionar_estados() -> void:
	if not estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
		if is_on_floor():
			estado_actual = Estados.PARADO
		if velocidad.x != 0:
			estado_actual = Estados.CORRIENDO
		if not is_on_floor():
			estado_actual = Estados.SALTANDO

func controles(delta:float) -> void:
	#Movimiento Horizontal
	velocidad.x = 0
	if estado_actual != Estados.EN_CUERDA:
		if Input.is_action_pressed("ir_derecha"):
			velocidad.x = VELOCIDAD_HORIZONTAL * delta
		elif Input.is_action_pressed("ir_izquierda"):
			velocidad.x = -VELOCIDAD_HORIZONTAL * delta
	#Saltar
	if is_on_floor():
		tiempo_en_aire = 0.0
	else:
		tiempo_en_aire += delta
	
	if not estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
		if Input.is_action_just_pressed("saltar") and saltos < 1:
			if is_on_floor():
				saltar(delta)
			else:
				if tiempo_en_aire < COYOTE_TIME:
					saltar(delta)

func saltar(delta:float) -> void:
	velocidad.y += POTENCIA_SALTO * delta
	saltos += 1

func impacto_caida() -> void:
	if velocidad.y == 0 and velocidad_anterior.y != 0:
		if sqrt(pow(velocidad_anterior.y - velocidad.y, 2)) > 160:
			crear_polvo()
			emit_signal("caida")

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

func _on_Escalera_escalando(esta:bool) -> void:
	if esta:
		estado_actual = Estados.ESCALANDO
	else:
		estado_actual = 0

func _on_CuerpoJugador_area_entered(area:Area2D) -> void:
	if area.is_in_group("obstaculos"):
		get_tree().reload_current_scene()

func cogio_escalera(esta:bool) -> void:
	if esta:
		estado_actual = Estados.EN_CUERDA
	else:
		estado_actual = 0


func _on_CuerpoJugador_body_entered(body):
	if body.name == "Tortuga":
		tortuga = body


func _on_CuerpoJugador_body_exited(body):
	if body.name == "Tortuga":
		tortuga = null
