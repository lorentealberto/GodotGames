extends Area

var activado: bool

func _ready() -> void:
	activado = false

func _process(delta: float) -> void:
	if activado:
		$Modelo.visible = true
	else:
		$Modelo.visible = false
