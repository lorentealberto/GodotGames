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
var velocidad_anterior:Vector2 = Vector2.ZERO

var cuerda:Area2D = null
var tortuga:StaticBody2D = null

const COYOTE_TIME:float = 0.125
var tiempo_en_aire:float = 0.0
var saltos:int = 0

"""var en_fondo_escalera:bool = false
var escalera:Area2D = null"""
var escalando:bool = false

func _process(_delta):
	gestionar_cuerda()
	comprobar_espinas_tortuga()
	gestionar_temporizador_cuerda()
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

func comprobar_espinas_tortuga() -> void:
	if tortuga != null:
		if tortuga.tiene_espinas_fuera():
			get_tree().reload_current_scene()

func gestionar_cuerda() -> void:
	if cuerda != null:
		position = cuerda.obtener_posicion_eslabon(10)
		rotation_degrees = cuerda.rotation_degrees

func gestionar_temporizador_cuerda() -> void:
	if !$TemporizadorCuerda.is_stopped():
		$Cuerpo.set_deferred("disabled", true)
		cuerda = null
		limpiar_estado_actual()
	else:
		$Cuerpo.set_deferred("disabled", false)

func impacto_caida() -> void:
	if velocidad.y == 0 and velocidad_anterior.y != 0:
		if (sqrt(pow(velocidad_anterior.y - velocidad.y, 2))) > 160:
			crear_polvo()
			emit_signal("caida")

func aplicar_gravedad(delta:float) -> void:
	if not is_on_floor() and not estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
		velocidad.y += GRAVEDAD * delta
	else:
		saltos = 0

func controles(delta:float) -> void:
	#Movimiento horizontal
	velocidad.x = 0
	if not estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
		if Input.is_action_pressed("ir_derecha"):
			velocidad.x += VELOCIDAD_HORIZONTAL * delta
		elif Input.is_action_pressed("ir_izquierda"):
			velocidad.x -= VELOCIDAD_HORIZONTAL * delta
	#Saltar
	
	if $RayCast2D.is_colliding():
		tiempo_en_aire = 0.0
	else:
		tiempo_en_aire += delta
		
	if estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
		velocidad.y = 0
		if Input.is_action_pressed("saltar"):
			if estado_actual == Estados.EN_CUERDA:
				$TemporizadorCuerda.start()
			velocidad.y += POTENCIA_DE_SALTO / 3 * delta
	elif Input.is_action_just_pressed("saltar") and saltos < 1:
		if $RayCast2D.is_colliding():
			saltar(delta)
		else:
			if tiempo_en_aire < COYOTE_TIME:
				saltar(delta)

func saltar(delta:float) -> void:
	velocidad.y += POTENCIA_DE_SALTO * delta
	saltos += 1

func gestionar_estados() -> void:
	if not estado_actual in [Estados.ESCALANDO, Estados.EN_CUERDA]:
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
			animated_sprite.play("saltando")

func actualizar_direccion() -> void:
	if velocidad.x < 0:
		animated_sprite.flip_h = true
	elif velocidad.x > 0:
		animated_sprite.flip_h = false

func gestionar_escalera() -> void:
	if escalando:
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

func limpiar_estado_actual() -> void:
	estado_actual = 0

func _on_Cuerpo_area_entered(area):
	if area.name == "Foso Cocodrilos" or area.name == "ArenasMovedizas":
		get_tree().reload_current_scene()

	if area.name == "Cuerda":
		cuerda = area
		estado_actual = Estados.EN_CUERDA

	if area.is_in_group("sierras"):
			get_tree().reload_current_scene()
	
	if area.is_in_group("enemigos"):
		get_tree().reload_current_scene()

func _on_Cuerpo_area_exited(area):
	if area.name == "Cuerda":
		cuerda = null
		rotation_degrees = 0

func _on_Cuerpo_body_entered(body):
	if body.is_in_group("tortugas"):
		tortuga = body

func _on_Cuerpo_body_exited(body):
	if body.is_in_group("tortugas"):
		tortuga = null
