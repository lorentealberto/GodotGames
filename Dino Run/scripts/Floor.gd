extends Node2D

onready var _parts:Array = [$Sprite, $Sprite2]

var _texture_width:float

func _ready():
	_texture_width = _parts[0].texture.get_size().x * _parts[0].scale.x

func _process(delta):
	for part in _parts:
		part.position.x -= Settings.FLOOR_VELOCITY * delta
		_reset(part)

func _reset(part:Sprite) -> void:
	if part.position.x < -_texture_width:
		part.position.x += 2 * _texture_width
