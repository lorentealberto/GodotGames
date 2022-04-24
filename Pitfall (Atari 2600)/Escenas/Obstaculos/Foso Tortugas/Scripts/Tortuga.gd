extends StaticBody2D

enum Estados { PARADO_ESPINAS_FUERA, PARADO_ESPINAS_DENTRO, SACANDO_ESPINAS, ENTRANDO_ESPINAS }
var estado_actual:int = Estados.PARADO_ESPINAS_DENTRO

func _process(delta):
	gestionar_animaciones()

func gestionar_animaciones() -> void:
	match estado_actual:
		Estados.PARADO_ESPINAS_DENTRO:
			$AnimatedSprite.play("parado_espinas_dentro")
		Estados.PARADO_ESPINAS_FUERA:
			$AnimatedSprite.play("parado_espinas_fuera")
		Estados.ENTRANDO_ESPINAS:
			$AnimatedSprite.play("entrando_espinas")
		Estados.SACANDO_ESPINAS:
			$AnimatedSprite.play("sacando_espinas")

func _on_AnimatedSprite_animation_finished():
	match $AnimatedSprite.animation:
		"sacando_espinas":
			estado_actual = Estados.PARADO_ESPINAS_FUERA
		"entrando_espinas":
			estado_actual = Estados.PARADO_ESPINAS_DENTRO
		_:
			$CPUParticles2D.emitting = true

func _on_Timer_timeout():
	match estado_actual:
		Estados.PARADO_ESPINAS_DENTRO:
			estado_actual = Estados.SACANDO_ESPINAS
		Estados.PARADO_ESPINAS_FUERA:
			estado_actual = Estados.ENTRANDO_ESPINAS

func tiene_espinas_fuera() -> bool:
	return estado_actual in [Estados.PARADO_ESPINAS_FUERA, Estados.SACANDO_ESPINAS]
