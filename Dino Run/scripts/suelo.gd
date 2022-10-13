extends StaticBody2D

# AJUSTES
const VELOCIDAD: float = -100.0


# VARIABLES DEL SISTEMA
onready var _partes: Array = [$Sprite, $Sprite2]
var _ancho_sprite: float


"""Se ejecuta una única vez cuando el script está listo."""
func _ready() -> void:
	_ancho_sprite = _partes[0].texture.get_size().x * _partes[0].scale.x


"""Se ejecuta de manera cíclica todos los framesd del juego.
Parámetros:
	delta: float -> Tiempo en MS que ha transcurrido desde la última vez que se
	ejecutó esté método."""
func _process(delta: float) -> void:
	for parte in _partes:
		parte.position.x += VELOCIDAD * delta
		_resetear(parte)


"""Si el sprite pasado como parámetro cumple una determinada condición, éste se
	moverá hasta el
	final de la ventana de juego.
Parámetros:
	parte: Sprite -> Sprite que debe cumplir la condición."""
func _resetear(parte: Sprite) -> void:
	if parte.position.x < -_ancho_sprite:
		parte.position.x += 2 * _ancho_sprite
