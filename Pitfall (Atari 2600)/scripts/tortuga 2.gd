extends StaticBody2D

onready var animated_sprite:AnimatedSprite = $AnimatedSprite
onready var cpu_particles:CPUParticles2D = $CPUParticles2D
onready var timer:Timer = $Timer

enum Estados { PARADO_ESPINAS_FUERA, PARADO_ESPINAS_DENTRO, SACANDO_ESPINAS, ENTRANDO_ESPINAS }
var estado_actual:int = Estados.PARADO_ESPINAS_DENTRO

func _ready():
	timer.connect("timeout", self, "intercambiar_estado")
	animated_sprite.connect("animation_finished", self, "animacion_terminada")
func _process(delta):
	gestionar_animaciones()

func gestionar_animaciones() -> void:
	match estado_actual:
		Estados.PARADO_ESPINAS_DENTRO:
			animated_sprite.play("parado_espinas_dentro")
		Estados.PARADO_ESPINAS_FUERA:
			animated_sprite.play("parado_espinas_fuera")
		Estados.ENTRANDO_ESPINAS:
			animated_sprite.play("entrando_espinas")
		Estados.SACANDO_ESPINAS:
			animated_sprite.play("sacando_espinas")

func animacion_terminada() -> void:
	match animated_sprite.animation:
		"sacando_espinas":
			estado_actual = Estados.PARADO_ESPINAS_FUERA
		"entrando_espinas":
			estado_actual = Estados.PARADO_ESPINAS_DENTRO
		_:
			cpu_particles.emitting = true

func intercambiar_estado() -> void:
	match estado_actual:
		Estados.PARADO_ESPINAS_DENTRO:
			estado_actual = Estados.SACANDO_ESPINAS
		Estados.PARADO_ESPINAS_FUERA:
			estado_actual = Estados.ENTRANDO_ESPINAS

func tiene_espinas_fuera() -> bool:
	return estado_actual in [Estados.PARADO_ESPINAS_FUERA, Estados.SACANDO_ESPINAS]
