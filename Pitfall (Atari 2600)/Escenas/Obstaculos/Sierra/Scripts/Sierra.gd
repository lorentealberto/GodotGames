extends Area2D

signal vibracion

export(bool) var estatica

const VELOCIDAD_HORIZONTAL:float = -25.0
var suelo:StaticBody2D = null

func _ready():
	if not estatica:
		$AnimatedSprite.play("encendida")
		$CPUParticles2D.emitting = true
	else:
		$AnimatedSprite.play("apagada")
		$CPUParticles2D.emitting = false

func _process(delta):
	if suelo != null and not estatica:
		$CPUParticles2D.emitting = true
	else:
		$CPUParticles2D.emitting = false

func _physics_process(delta):
	if not estatica:
		position.x += VELOCIDAD_HORIZONTAL * delta
		reiniciar_posicion()

func reiniciar_posicion() -> void:
	if position.x < 0:
		position.x = get_viewport_rect().size.x

func esta_encendida() -> bool:
	return $AnimatedSprite.animation == "encendida"

func _on_Timer_timeout():
	emit_signal("vibracion")


func _on_Sierra_body_entered(body):
	if body.is_in_group("Suelo"):
		suelo = body


func _on_Sierra_body_exited(body):
	if body.is_in_group("Suelo"):
		suelo = null
