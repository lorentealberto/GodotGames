extends Area2D

var activado: bool

func _ready() -> void:
	activado = false

func _process(delta: float) -> void:
	if activado:
		$Sprite.visible = true
	else:
		$Sprite.visible = false
