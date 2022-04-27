extends Area2D

signal vibracion

onready var camara:Camera2D = get_parent().get_node("Camara")
onready var animated_sprite:AnimatedSprite = $AnimatedSprite
onready var cpu_particles:CPUParticles2D = $CPUParticles2D
onready var timer:Timer = $Timer

export(bool) var dinamica

const VELOCIDAD_HORIZONTAL:float = -25.0
var suelo:StaticBody2D = null

func _ready():
	add_to_group("obstaculos")
	connect("body_entered", self, "tocando_suelo")
	connect("body_exited", self, "no_toca_suelo")
	timer.connect("timeout", self, "tiempo_acabado")
	
	if dinamica:
		animated_sprite.play("encendida")
		cpu_particles.emitting = true
		timer.start()
# warning-ignore:return_value_discarded
		connect("vibracion", camara, "comenzar", [0.1, 7.5, 0.2, 1])
	else:
		animated_sprite.play("apagada")
		cpu_particles.emitting = false

func _process(_delta):
	if suelo != null and dinamica:
		cpu_particles.emitting = true
	else:
		cpu_particles.emitting = false

func _physics_process(delta):
	if dinamica:
		position.x += VELOCIDAD_HORIZONTAL * delta
		reiniciar_posicion()

func reiniciar_posicion() -> void:
	if position.x < 0:
		position.x = get_viewport_rect().size.x

func esta_encendida() -> bool:
	return animated_sprite.animation == "encendida"

func tiempo_acabado():
	emit_signal("vibracion")


func tocando_suelo(body):
	if body.is_in_group("suelo"):
		suelo = body


func no_toca_suelo(body):
	if body.is_in_group("suelo"):
		suelo = null
